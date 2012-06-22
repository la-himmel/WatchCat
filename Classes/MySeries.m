#import "MySeries.h"
#import "utils.h"
#import "JSONKit.h"

@implementation MySeries

@synthesize favourites = favourites_;
@synthesize bookmarked = bookmarked_;

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }    
    favourites_ = [[NSMutableArray alloc] init];
    bookmarked_ = [[NSMutableArray alloc] init];

//    favourites_ = nil; 
//    bookmarked_ = nil; 

    return self;
}

- (void)loadTest
{
    //test
    TVShow *show4 = [[TVShow alloc] init];
    show4.num = 4;
    show4.name = @"Vampire diaries";
    show4.episodes = [NSArray array];
    
    TVShow *show5 = [[TVShow alloc] init];
    show5.num = 5;
    show5.name = @"Two and a half men";
    show5.episodes = [NSArray array];
    
    TVShow *show6 = [[TVShow alloc] init];
    show6.num = 6;
    show6.name = @"How i met your mother";
    show6.episodes = [NSArray array];
    
    TVShow *show7 = [[TVShow alloc] init];
    show7.num = 7;
    show7.name = @"Daria";
    show7.episodes = [NSArray array];
    
    [favourites_ addObject:show4];
    [favourites_ addObject:show5];
    [favourites_ addObject:show6];
    [favourites_ addObject:show7];
    
    DLOG("nothing to do, favs: %d", [favourites_ count]);
}

- (BOOL)load
{
//    [self loadTest];
//    return YES;
            
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask, 
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *pathFavourites = [documentsDir stringByAppendingPathComponent:@"Favourites"];
        
    NSError *error;
    NSString *json = [[NSString alloc] initWithContentsOfFile:pathFavourites encoding:NSUnicodeStringEncoding error:&error];
    
    DLOG("json: %@", json);    
    NSArray *favs = [json objectFromJSONString];

    DLOG("%d", [favs count]);
    favourites_ = [self extractFromJsonArray:favs];
        
    BOOL success = NO;
    if (favourites_ != nil) {
        success = YES;
        DLOG("favs LOADED: %d", [favourites_ count]);        
    } else {
        DLOG("favs were NOT LOADED");        
    }
    
//    NSString *pathBookmarked = [documentsDir stringByAppendingPathComponent:@"Bookmarked"];    
//    NSMutableArray *bms = [[NSMutableArray alloc] initWithContentsOfFile:pathBookmarked];
//    bookmarked_ = [self extractArray:bms];
    
//    if (bookmarked_ != nil && success) {
//        success = YES;
//        DLOG("book LOADED: %d", [bookmarked_ count]);        
//    } else {
//        success = NO;
//        DLOG("book NOT LOADED");
//    }
        
//    NSLog(@"%@", success ? @"Data was loaded." : @"Unable to load data" );    
    return success;
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
    DLOG("extractFromJsonArray:");
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for (NSString *show in array) {
        [ma addObject:[TVShow showFromJsonString:show]];        
    }
    
    return ma; 
}

- (NSArray *)convertArray:(NSArray *)array
{
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for (TVShow *show in array) {
        [ma addObject:[show dictionary]];        
    }

    return ma; 
}     

- (NSMutableArray *)extractArray:(NSArray *)array
{
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *show in array) {
        [ma addObject:[TVShow showFromDictionary:show]];        
    }
    
    return ma; 
}

- (void)save
{
    DLOG("count before saving: %d %d", [favourites_ count], [bookmarked_ count]);
    [self saveFavourites];
    [self saveBookmarked];
}

- (void)saveFavourites
{
    DLOG("1");
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask,  
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    
    NSString *pathFavourites = [documentsDir stringByAppendingPathComponent:@"Favourites"];    
    
//    NSArray *converted = [self convertArray:favourites_];

    DLOG("1");
    NSArray *converted = [self convertToJsonArray:favourites_]; 
    DLOG("1");
    NSString *JSON = [converted JSONString];    
    DLOG("Serialized: %@", JSON);
    
//    BOOL success = [converted writeToFile:pathFavourites atomically:YES];
    NSError *error;
    DLOG("1");
    BOOL success = [JSON writeToFile:pathFavourites atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    
    DLOG("saved: %d %d", [favourites_ count], [converted count]);
    
    NSLog(@"%@", success ? @"File was saved." : @"File was not saved.");    
}

- (void)saveBookmarked
{
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask,  
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    
    NSString *pathBookmarked = [documentsDir stringByAppendingPathComponent:@"Bookmarked"];  
    
    NSArray *converted = [self convertArray:bookmarked_];    
    BOOL success = [converted writeToFile:pathBookmarked atomically:YES];
    
    DLOG("saved: %d %d", [bookmarked_ count], [converted count]);
    
    NSLog(@"%@", success ? @"File was bookmarked." : @"File was not bookmarked.");    
}


- (void)addToFavorites:(TVShow *)show 
{
    BOOL found = NO;
    for (TVShow* show_ in favourites_) {
        if ([show isEqual:show_]) {
            found = YES;
        }
    }    
    if (!found) {
        [favourites_ addObject:show];
    }
    [self save];
}

- (void)removeFromFavorites:(TVShow *)show
{
    for (TVShow* show_ in favourites_) {
        if ([show isEqual:show_]) {
            [favourites_ removeObject:show_];
        }
    }  
}

- (void)rememberShow:(TVShow *)show
{
    BOOL found = NO;
    for (TVShow* show_ in bookmarked_) {
        if ([show isEqual:show_]) {
            found = YES;
        }
    }    
    if (!found) {
        [bookmarked_ addObject:show];
    }
}

- (void)forgetShow:(TVShow *)show
{
    for (TVShow* show_ in bookmarked_) {
        if ([show isEqual:show_]) {
            [bookmarked_ removeObject:show_];
        }
    }  
}

@end
