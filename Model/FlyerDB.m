//
//  FlyerDB.m
//  PVMNT
//
//  Created by Phil Meyers IV on 10/16/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "FlyerDB.h"
#import <SDWebImage/SDWebImageManager.h>
#import <MagicalRecord/MagicalRecord.h>  
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "CD_V2_Category.h"
#import "CD_V2_Flyer.h"
#import "CD_Image.h"
#import "RK_Category.h"
#import "RK_Flyer.h"
#import "NSDate+Utilities.h"
#import "SVPullToRefresh.h"
//#import "PVMNT_CONSTANTS.h"
#import "SchoolPickerViewController.h"

NSString *const kFlyerDBRemovedFlyersNotification            = @"kFlyerDBRemovedFlyersNotification";
NSString *const kFlyerDBAddedFlyerNotification              = @"kFlyerDBAddedFlyerNotification";
@interface FlyerDB() 
@property (strong, nonatomic) dispatch_queue_t concurrentRestfulServicesQueue;
@property (strong, nonatomic) dispatch_group_t restfulServicesGroup;
@property (strong, nonatomic) dispatch_group_t imageDownloadingGroup;
@property (strong, nonatomic) NSMutableArray *temporaryDB;
@property (nonatomic) BOOL schoolExists;
@end

@implementation FlyerDB
#pragma mark - Public Methods

- (BOOL)schoolExists
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey];
}

/**
 *  Creates a shared instance for the FlyerDB model, which is responsible for loading, storing, and organizing the flyers.
 *
 *  @return The shared instance for the FlyerDB model.
 */
+ (id)sharedInstance
{
    static FlyerDB *sharedFlyerDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFlyerDB = [[FlyerDB alloc] init];
        [sharedFlyerDB setupFlyerDB];
    });
    return sharedFlyerDB;
}

- (void)setupFlyerDB
{
    self.concurrentRestfulServicesQueue = dispatch_queue_create("com.pvmnt.pvmntapp.restfulServicesQueue", DISPATCH_QUEUE_CONCURRENT);
    self.imageDownloadingGroup = dispatch_group_create();
    self.restfulServicesGroup = dispatch_group_create();
    [self configureRestKit];
    
}

/**
 *  Configuration of RestKit API to access the pvmnt API through RESTful services
 */
- (void)configureRestKit
{
    NSURL *baseURL = [NSURL URLWithString:@"https://www.pvmnt.com/api/v2/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

    // setup object mappings
    RKObjectMapping *flyerMapping = [RKObjectMapping mappingForClass:[RK_Flyer class]];
    [flyerMapping addAttributeMappingsFromDictionary:@{@"id":@"flyerId",
                                                       @"image.url":@"imageURL",
                                                       @"event_date":@"event_date",
                                                       @"location":@"location",
                                                       @"description":@"flyerDescription",
                                                       @"title":@"title",
                                                       @"created_at":@"created_at",
                                                       @"updated_at":@"updated_at"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *flyerResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:flyerMapping
                                                 method:RKRequestMethodGET
                                                pathPattern:@"flyers"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:flyerResponseDescriptor];
    
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[RK_Category class]];
    [categoryMapping addAttributeMappingsFromDictionary:@{@"id":@"categoryId",
                                                          @"name":@"categoryName"}];
    RKResponseDescriptor *categoryDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"categories"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:categoryDescriptor];
    
}

//----------------------------------RESTFUL SERVICES FETCHING------------------------------------//


- (void)fetchAllWithCompletionBlock:(void (^)())completionBlock
{
    if (self.schoolExists) {
        dispatch_async(self.concurrentRestfulServicesQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });

            [self fetchAllFlyers];
            [self fetchAllCategories];
            
            dispatch_group_wait(self.restfulServicesGroup, DISPATCH_TIME_FOREVER);
            
            dispatch_group_wait(self.imageDownloadingGroup, 5 * NSEC_PER_SEC);
            
            [NSThread sleepForTimeInterval:1.5];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self deleteOldFlyers];
                if (completionBlock) {
                    completionBlock();
                }
            });
        });
    }
}

- (void)fetchAllCategories
{
    dispatch_sync(self.concurrentRestfulServicesQueue, ^{
        dispatch_group_enter(self.restfulServicesGroup);
    });
    
//    NSLog(@"Entering restfulServicesGroup");
    [[RKObjectManager sharedManager] getObjectsAtPath:@"categories"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  for (RK_Category *rkCategory in mappingResult.array) {
                                                      CD_V2_Category *newCategory = [CD_V2_Category MR_findFirstByAttribute:@"categoryId" withValue:@(rkCategory.categoryId)];
                                                      if (!newCategory) { //There aren't any categories with the same id
                                                          newCategory = [CD_V2_Category MR_createEntity];
                                                          newCategory.categoryId    = @(rkCategory.categoryId);
                                                          newCategory.name          = rkCategory.categoryName;
                                                          newCategory.urlExtension  = rkCategory.categoryURL;
                                                      }
                                                  }
                                                  [self fetchAllFlyersInCategories];
                                                  dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                      dispatch_group_leave(self.restfulServicesGroup);
//                                                      NSLog(@"Leaving restfulServicesGroup");
                                                  });
                                                  
                                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                               dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                   dispatch_group_leave(self.restfulServicesGroup);
//                                                   NSLog(@"Error: Leaving restfulServicesGroup");
                                               });
                                           }];
}

- (void)fetchAllFlyersInCategories
{
    NSArray *categories = [CD_V2_Category MR_findAll];
    for (CD_V2_Category *category in categories) {
        dispatch_sync(self.concurrentRestfulServicesQueue, ^{
            dispatch_group_enter(self.restfulServicesGroup);
//            NSLog(@"Entering restfulServicesGroup");
        });
        
        [[RKObjectManager sharedManager] getObjectsAtPath:@"flyers"
                                               parameters: @{@"category":category.urlExtension}
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      NSMutableArray *cdFlyers = [[NSMutableArray alloc] initWithCapacity:mappingResult.array.count];
                                                      for (RK_Flyer *rkFlyer in mappingResult.array) {
                                                          CD_V2_Flyer *flyer = [self flyerFromRK_Flyer:rkFlyer];
                                                          [flyer addFlyerCategoriesObject:category];
                                                          [flyer updateWithRK_Flyer:rkFlyer];
                                                          
                                                          [cdFlyers addObject:flyer];
                                                      }
                                                      
                                                      [self downloadImagesForCD_V2_Flyers:cdFlyers];
                                                      dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                          dispatch_group_leave(self.restfulServicesGroup);
//                                                          NSLog(@"Leaving restfulServicesGroup");
                                                      });
                                                      
                                                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                          dispatch_group_leave(self.restfulServicesGroup);
//                                                          NSLog(@"Error: Leaving restfulServicesGroup");
                                                      });
                                                  }];

    }
}


/**
 *  API_v1 implementation to fetch all fliers
 */
- (void)fetchAllFlyers
{
    dispatch_sync(self.concurrentRestfulServicesQueue, ^{
        dispatch_group_enter(self.restfulServicesGroup);
//        NSLog(@"Entering restfulServicesGroup");
    });
    [[RKObjectManager sharedManager] getObjectsAtPath:@"flyers"
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      NSMutableArray *cdFlyers = [[NSMutableArray alloc] initWithCapacity:mappingResult.array.count];
                                                      for (RK_Flyer *rkFlyer in mappingResult.array) {
                                                          CD_V2_Flyer *flyer = [self flyerFromRK_Flyer:rkFlyer];
                                                          [flyer updateWithRK_Flyer:rkFlyer];
                                                          
                                                          [cdFlyers addObject:flyer];
                                                      }
                                                      
                                                      [self downloadImagesForCD_V2_Flyers:cdFlyers];
                                                      dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                          dispatch_group_leave(self.restfulServicesGroup);
//                                                          NSLog(@"Leaving restfulServicesGroup");
                                                      });
                                                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Failed to fetch all fliers from API_v2 due to error: %@", error);
                                                      dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                          dispatch_group_leave(self.restfulServicesGroup);
//                                                          NSLog(@"Error: Leaving restfulServicesGroup");
                                                      });
                                                  }];

}

- (void)deleteOldFlyers
{
    NSDate *today = [[NSDate date] dateAtStartOfDay];
    NSPredicate *predicateForDatesEarlierThanToday = [NSPredicate predicateWithFormat:@"event_date < %@", today];
    NSArray *flyers = [CD_V2_Flyer MR_findAllWithPredicate:predicateForDatesEarlierThanToday];
    NSArray *flyerIds = [flyers valueForKey:@"flyerId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFlyerDBRemovedFlyersNotification object:self userInfo:[NSDictionary dictionaryWithObjects:flyers forKeys:flyerIds]];
    //    NSArray *dates = [flyers valueForKey:@"event_date"];
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    SDImageCache *imageCache = imageManager.imageCache;
    
    for (CD_V2_Flyer *flyer in flyers) {
        NSString *imageCacheKeyForFlyer = [imageManager cacheKeyForURL:[NSURL URLWithString:flyer.image.imageURL]];
        [imageCache removeImageForKey:imageCacheKeyForFlyer];
        [flyer.image MR_deleteEntity];
        [flyer MR_deleteEntity];
    }
    
    NSLog(@"Deleted %lu old flyers.", flyers.count);
    //    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

//------------------------------------DATABASE CONSTRUCTION-----------------------------------//

- (CD_V2_Flyer *)flyerFromFlyerId:(NSUInteger)flyerId
{
    return [CD_V2_Flyer MR_findFirstByAttribute:@"flyerId" withValue:@(flyerId)];
}

- (CD_V2_Flyer *)flyerFromRK_Flyer:(RK_Flyer *)rkFlyer
{
    CD_V2_Flyer *flyer = [self flyerFromFlyerId:rkFlyer.flyerId];
    if (!flyer) {
        flyer = [self createCD_V2_FlyerFromRK_Flyer:rkFlyer];
    }
    return flyer;
}

- (CD_V2_Flyer *)createCD_V2_FlyerFromRK_Flyer:(RK_Flyer *)rkFlyer
{
    CD_V2_Flyer *newFlyer = [CD_V2_Flyer MR_createEntity];
    newFlyer.approved = @(rkFlyer.approved);
    newFlyer.created_at = rkFlyer.created_at;
    newFlyer.updated_at = rkFlyer.updated_at;
    newFlyer.flyerId = @(rkFlyer.flyerId);
    newFlyer.location = [rkFlyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newFlyer.title = [rkFlyer.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newFlyer.event_date = [rkFlyer.event_date dateAtStartOfDay];
    newFlyer.event_time = rkFlyer.event_date;
    newFlyer.desc = [rkFlyer.flyerDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    NSAttributedString *markdownString = [[NSAttributedString alloc] initWithData:[rkFlyer.flyerDescription dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
//    newFlyer.desc = [[markdownString string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CD_Image *image = [CD_Image MR_createEntity];
    NSString *imageURL = [rkFlyer.imageURL stringByReplacingOccurrencesOfString:@"pvmnt.s3.amazonaws.com" withString:@"d91h6uwlhrn81.cloudfront.net"];
    image.imageURL = imageURL;
    image.imageDownloaded = [NSNumber numberWithBool:NO];
    newFlyer.image = image;
    
    //    [newFlyer convertHTMLMarkdownDescriptionToPlainText];
    //    [newFlyer performSelectorInBackground:@selector(convertHTMLMarkdownDescriptionToPlainText) withObject:nil];
    return newFlyer;
}

- (void)downloadImageForCD_V2_Flyer:(CD_V2_Flyer *)cdFlyer
{
    if (![cdFlyer.image.imageDownloaded boolValue]) {
        dispatch_sync(self.concurrentRestfulServicesQueue, ^{
            dispatch_group_enter(self.imageDownloadingGroup);
//            NSLog(@"Entering imageDownloadGroup");
        });
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:cdFlyer.image.imageURL]
                                                        options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                            cdFlyer.image.imageDownloaded = @(YES);
                                                            cdFlyer.image.height = [NSNumber numberWithFloat:image.size.height];
                                                            cdFlyer.image.width = [NSNumber numberWithFloat:image.size.width];;
                                                            
                                                            
                                                            dispatch_sync(self.concurrentRestfulServicesQueue, ^{
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:kFlyerDBAddedFlyerNotification object:cdFlyer userInfo:nil];
                                                                dispatch_group_leave(self.imageDownloadingGroup);
                                                                //                                                                NSLog(@"Leaving imageDownloadGroup");
                                                            });
                                                        }];
    }
    
}

- (void)downloadImagesForCD_V2_Flyers:(NSArray *)cdFlyers
{
    for (CD_V2_Flyer *flyer in cdFlyers) {
        [self downloadImageForCD_V2_Flyer:flyer];
    }
}

//--------------------------DATABASE ACCESSORS----------------------//

- (NSArray *)flyerDates
{
    NSArray *dates = [[CD_V2_Flyer MR_findByAttribute:@"image.imageDownloaded" withValue:@(YES) andOrderBy:@"event_date" ascending:YES] valueForKeyPath:@"@distinctUnionOfObjects.event_date"];
    dates = [dates sortedArrayUsingSelector:@selector(compare:)];
    return dates;
}

- (NSArray *)flyersAtDate:(NSDate *)date
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(event_date == %@) AND (image.imageDownloaded) = %@", date, @(YES)];
    NSArray *flyers = [CD_V2_Flyer MR_findAllSortedBy:@"event_time" ascending:YES withPredicate:filter];
//    flyers = [flyers sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"event_time" ascending:YES]]];
    return flyers;
}

- (NSArray *)allFlyersSortedByDateAndTime
{
    return [CD_V2_Flyer MR_findByAttribute:@"image.imageDownloaded" withValue:@(YES) andOrderBy:@"event_time" ascending:YES];
}

- (NSArray *)allFlyersSortedByUploadDate
{
    return [CD_V2_Flyer MR_findByAttribute:@"image.imageDownloaded" withValue:@(YES) andOrderBy:@"created_at" ascending:NO];
}


- (NSArray *)allCategoriesSortedByName
{
    return [CD_V2_Category MR_findAllSortedBy:@"name" ascending:YES];
}


@end
