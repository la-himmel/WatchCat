#import "MySeries.h"
#import "utils.h"
#import "JSONKit.h"
#import "XMLDeserialization.h"
#import "Episode.h"

@implementation MySeries

@synthesize favourites = favourites_;
@synthesize bookmarked = bookmarked_;

#define PATH_FAVOURITES @"Favourites"
#define PATH_BOOKMARKED @"Bookmarked"

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }    
    favourites_ = [[NSMutableArray alloc] init];
    bookmarked_ = [[NSMutableArray alloc] init];

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
            
            if ([airdate compare: now] != NSOrderedAscending) {
                DLOG("air date: %@ is LATER than %@", [airdate description], [now description]);
                currentShow.nearestAirDate = ep.airDate;
                currentShow.nearestId = [NSString stringWithFormat:@"%d", ep.num];
                
                [self setNotificationOnDate:airdate episodeId:ep.num show:currentShow.name];
                
                return;
            }       
        }
    });  
    
    return episodes;
          
}

- (void)setNotificationOnDate:(NSDate *)date episodeId:(int)epId show:(NSString *)show
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.day = 4;
    dc.month = 7;
    dc.year = 2012;
    dc.hour = 15;
    dc.minute = 45;               

    NSDate *someDate = [[NSCalendar currentCalendar] dateFromComponents:dc];
    DLOG("result date: %@", [someDate description]);
    NSDate *now = [NSDate date];
    DLOG("and now its: %@", [now description]);
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];    
    localNotification.fireDate = date;
    localNotification.alertAction = @"Open app";
    localNotification.alertBody = [show stringByAppendingString:@"'s next episode is coming today!"];
    localNotification.timeZone = [[NSCalendar currentCalendar] timeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    DLOG("notifications: %@", [[localNotification fireDate] description]);
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
