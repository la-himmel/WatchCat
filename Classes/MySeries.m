#import "MySeries.h"
#import "utils.h"
#import "JSONKit.h"
#import "XMLDeserialization.h"
#import "Episode.h"
#import "JSONKit.h"

@interface MySeries()
@property (nonatomic, strong) NSString *lastUpdated;
@property (nonatomic, strong) NSString *whenToUpdate;
@property (nonatomic, strong) NSMutableArray *scheduledTimes;
@end

@implementation MySeries

@synthesize favourites = favourites_;
@synthesize bookmarked = bookmarked_;

@synthesize whenToUpdate = whenToUpdate_;
@synthesize lastUpdated = lastUpdated_;

@synthesize scheduledTimes = scheduledTimes_;

#define PATH_FAVOURITES @"Favourites"
#define PATH_BOOKMARKED @"Bookmarked"
#define PATH_UPDATE @"UpdateInfo"

#define KEY_LAST_UPDATED @"LastUpdated"
#define KEY_WHEN_TO_UPDATE @"WhenToUpdate"

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }    
    favourites_ = [[NSMutableArray alloc] init];
    bookmarked_ = [[NSMutableArray alloc] init];
    
    scheduledTimes_ = [[NSMutableArray alloc] init];
    
    //test. TODO: remove
    whenToUpdate_ = @"2012-12-12";
    lastUpdated_ = @"2012-10-12";

    return self;
}

- (NSArray *)downloadSeriesSyncWithId:(NSString *)seriesId
{
    NSURL *url = [NSURL URLWithString:[NSString
                                       stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%@/all/en.xml",
                                       seriesId]];    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    
    NSArray *episodes = parseEpisodes(xmlData);
    DLOG("Episode list was parsed, count: %d", [episodes count]);  
     
    return episodes;
}

- (NSArray *)downloadSeriesWithId:(NSString *)seriesId
{
    NSURL *url = [NSURL URLWithString:[NSString
                                       stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%@/all/en.xml",
                                       seriesId]];    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    
    __block NSArray *episodes;
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{  
        episodes = parseEpisodes(xmlData);
        DLOG("Episode list was parsed, count: %d", [episodes count]);  

        TVShow *currentShow;
        for (TVShow* show in favourites_) {
            if (show.idString == seriesId) {
                show.episodes = episodes;
                
                if (show.status != @"Ended") {
                    currentShow = show;
                }
            }
        }  
    
        NSDate *now = [NSDate date];
        for (Episode *ep in episodes) {
            NSString *dateStr = ep.airDate;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *airdate = [dateFormat dateFromString:dateStr];  
            
            if (airdate == nil)
                continue;
            
            //schedule only first nearest date
            if ([airdate compare: now] != NSOrderedAscending) {
                DLOG("air date: %@ is LATER than %@", [airdate description], [now description]);
                currentShow.nearestAirDate = ep.airDate;
                currentShow.lastScheduled = ep.airDate;
                currentShow.nearestId = [NSString stringWithFormat:@"%d", ep.num];
                
                [self setNotificationOnDate:airdate episodeId:ep.num show:currentShow.name];
                
                return;
            }       
        }
    });  
    
    return episodes;
}

- (NSString *)getTodayString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *now = [dateFormat stringFromDate:[NSDate date]];
    
    return now;
}

- (void)saveUpdateInfo
{
    DLOG("lastUpdated: %@", lastUpdated_);
    DLOG("whenToUpdate: %@", whenToUpdate_);
    DLOG("Today: %@", [self getTodayString]);
    
    NSMutableDictionary *update = [[NSMutableDictionary alloc] init];
    [update setObject:lastUpdated_ forKey:KEY_LAST_UPDATED];
    [update setObject:whenToUpdate_ forKey:KEY_WHEN_TO_UPDATE];
    
    NSString *json = [update JSONString];
    DLOG("json: %@", json);

    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *path = [documentsDir stringByAppendingPathComponent:PATH_UPDATE];
    
    NSError *error;
    BOOL success = [json writeToFile:path atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    
    NSLog(@"%@", success ? @"UpdateInfo was saved." : @"UpdateInfo was not saved.");
}

- (void)loadUpdateInfo
{
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *path = [documentsDir stringByAppendingPathComponent:PATH_UPDATE];
    
    NSError *error;
    NSString *json = [[NSString alloc] initWithContentsOfFile:path
                                                     encoding:NSUnicodeStringEncoding error:&error];

    NSDictionary *update = [json objectFromJSONString];

    lastUpdated_ = [update objectForKey:KEY_LAST_UPDATED];
    whenToUpdate_ = [update objectForKey:KEY_WHEN_TO_UPDATE];
 
    DLOG("lastUpdated: %@", lastUpdated_);
    DLOG("whenToUpdate: %@", whenToUpdate_);
    DLOG("Today: %@", [self getTodayString]);
}

- (BOOL)needsUpdate
{
    DLOG("lastUpdated: %@", lastUpdated_);
    DLOG("whenToUpdate: %@", whenToUpdate_);
    DLOG("Today: %@", [self getTodayString]);
    
    if ([lastUpdated_ compare:[self getTodayString]] == NSOrderedSame) {
        return NO;
    }
    if ([lastUpdated_ compare:[self getTodayString]] == NSOrderedAscending) {
        if ([[self getTodayString] compare:whenToUpdate_] == NSOrderedAscending) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (void)refreshShows
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{
        
        for (TVShow *show in favourites_) {
            DLOG("Found: %@", show.name);
            
            NSURL *url = [NSURL URLWithString:[NSString
                                               stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%@/all/en.xml",
                                               show.idString]];
            NSData *xmlData = [NSData dataWithContentsOfURL:url];

            show.episodes = nil;
            show.episodes = parseEpisodes(xmlData);            
            
            for (Episode *ep in show.episodes) {
                NSString *dateStr = ep.airDate;
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *airdate = [dateFormat dateFromString:dateStr];
                
                if (airdate == nil)
                    continue;
                
                BOOL includeToday = NO;
                
                if (![show.lastScheduled length]) {
                    show.lastScheduled = [self getTodayString];
                    includeToday = YES;

                    //TODO: change today to yesterday for not to lose today episodes
                    //Todo: change the nearest episode field
                    //Todo: 
                }

                NSComparisonResult result = [dateStr compare: show.lastScheduled];
                
                if (( result == NSOrderedDescending && !includeToday ) ||
                    ( result != NSOrderedAscending && includeToday ))
                {
//                    DLOG("last: %@", show.lastScheduled);
//                    DLOG("airdate: %@, so SCHEDULE!", dateStr);
                    
                    show.lastScheduled = dateStr;
                    show.nearestId = [NSString stringWithFormat:@"%d", ep.num];
                    [self setNotificationOnDate:airdate episodeId:ep.num show:show.name];
                }
            }
            
            //Todo: check for status
            
            [scheduledTimes_ addObject:show.lastScheduled];
        }
        
        lastUpdated_ = [self getTodayString];
    });
    
}

- (void)setNextDate
{
    if (![scheduledTimes_ count]) {
        return;
    }
    
    NSString *closestTime = [scheduledTimes_ objectAtIndex:0];
    
    for (NSString *time in scheduledTimes_) {
        if ([closestTime compare:time] == NSOrderedDescending) {
            closestTime = time;
        }
    }
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *plusWeek = [[NSDateComponents alloc] init];
    [plusWeek setDay:+7];
    NSDate *weekAfter = [[NSCalendar currentCalendar] dateByAddingComponents:plusWeek
                                                                      toDate:today
                                                                     options:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *weekAfterString = [dateFormat stringFromDate:weekAfter];
    
    if ([weekAfterString compare:closestTime] == NSOrderedDescending) {
        whenToUpdate_ = closestTime;
    } else {
        whenToUpdate_ = weekAfterString;
    }
}

- (void)update
{
    [self loadUpdateInfo];
    if ([self needsUpdate]) {
        DLOG("So, we need update!");
        [self refreshShows];
        [self setNextDate];
        [self save];
//        [self saveUpdateInfo];
    } else {
        DLOG("So, we don't have to update.");
    }


}

- (void)setNotificationOnDate:(NSDate *)date episodeId:(int)epId show:(NSString *)show
{    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];    
    localNotification.fireDate = date;
    localNotification.alertAction = @"Open app";
    localNotification.alertBody = [show stringByAppendingString:@"'s next episode is coming today!"];
    localNotification.timeZone = [[NSCalendar currentCalendar] timeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
//    DLOG("notifications: %@", [[localNotification fireDate] description]);
}

- (BOOL)load
{
    [self loadPath:PATH_FAVOURITES];
    [self loadPath:PATH_BOOKMARKED];
    
    return YES;
}

- (BOOL)loadPath:(NSString *)stringPath
{
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask, 
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *path = [documentsDir stringByAppendingPathComponent:stringPath];
    
    NSError *error;
    NSString *json = [[NSString alloc] initWithContentsOfFile:path 
                                                     encoding:NSUnicodeStringEncoding error:&error];
    NSArray *items = [json objectFromJSONString];

    if (stringPath == PATH_FAVOURITES) {
        favourites_ = [self extractFromJsonArray:items];   
        if (favourites_ == nil) {
           DLOG("NOT LOADED"); 
           return NO;
        } 
    } else if (stringPath == PATH_BOOKMARKED) {
        bookmarked_ = [self extractFromJsonArray:items];  
        if (bookmarked_ == nil) {            
            DLOG("NOT LOADED"); 
            return NO;
        } 
    }
    return YES;
}

- (NSArray *)convertToJsonArray:(NSArray *)array
{
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for (TVShow *show in array) {
        [ma addObject:[show jsonString]];        
    }
    
    return ma; 
}

- (NSMutableArray *)extractFromJsonArray:(NSArray *)array
{
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for (NSString *show in array) {
        [ma addObject:[TVShow showFromJsonString:show]];        
    }
    
    return ma; 
}

- (void)save
{
    [self saveFavourites];
    [self saveBookmarked];
}

- (void)savePath:(NSString *)stringPath
{
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask,  
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *path = [documentsDir stringByAppendingPathComponent:stringPath];    
    
    NSArray *converted;
    if (stringPath == PATH_FAVOURITES) {
        converted = [self convertToJsonArray:favourites_]; 
    } else if (stringPath == PATH_BOOKMARKED) {
        converted = [self convertToJsonArray:bookmarked_]; 
    }

    NSString *JSON = [converted JSONString];    
    
    NSError *error;
    BOOL success = [JSON writeToFile:path atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    
    NSLog(@"%@", success ? @"File was saved." : @"File was not saved.");    
}

- (void)saveFavourites
{
    [self savePath:PATH_FAVOURITES];
}

- (void)saveBookmarked
{
    [self savePath:PATH_BOOKMARKED];
}


- (BOOL)addToFavorites:(TVShow *)show 
{
    for (TVShow* show_ in favourites_) {
        
        if ([show.idString isEqual:show_.idString]) {
            return NO;
        } 
    }    

    [favourites_ addObject:show];
    [self saveFavourites];
    
    [self downloadSeriesWithId:show.idString];                    
   
    //TODO: save
    return YES;
}

- (BOOL)rememberShow:(TVShow *)show
{
    for (TVShow* show_ in bookmarked_) {
        if ([show.idString isEqual:show_.idString]) {
            return NO;
        }
    }    

    [bookmarked_ addObject:show];
    [self saveBookmarked];
    return YES;
}

- (void)removeFromFavorites:(TVShow *)show
{
    if ([favourites_ count] == 0)
        return;
    
    for (TVShow* show_ in favourites_) {
        if ([show.idString isEqual:show_.idString]) {
            [favourites_ removeObject:show_];
            [self saveFavourites];
            return;
        }
    }  
}

- (void)forgetShow:(TVShow *)show
{
    if ([bookmarked_ count] == 0)
        return;
    
    
    for (TVShow* show_ in bookmarked_) {
        if ([show.idString isEqual:show_.idString]) {
            [bookmarked_ removeObject:show_];
            [self saveBookmarked];
            return;
        }
    }  
}

@end
