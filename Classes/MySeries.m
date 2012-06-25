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

    return self;
}

- (void)loadTest
{
    //test
    TVShow *show4 = [[TVShow alloc] init];
    show4.num = 4;
    show4.name = @"Vampire diaries";
    
    TVShow *show5 = [[TVShow alloc] init];
    show5.num = 5;
    show5.name = @"Two and a half men";
    
    TVShow *show6 = [[TVShow alloc] init];
    show6.num = 6;
    show6.name = @"How i met your mother";
    
    TVShow *show7 = [[TVShow alloc] init];
    show7.num = 7;
    show7.name = @"Daria";
    
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
    NSString *json = [[NSString alloc] initWithContentsOfFile:pathFavourites 
                                                     encoding:NSUnicodeStringEncoding error:&error];
    
    NSArray *favs = [json objectFromJSONString];
    favourites_ = [self extractFromJsonArray:favs];
        
    BOOL success = NO;
    if (favourites_ != nil) {
        success = YES;
//        DLOG("favs LOADED: %d", [favourites_ count]);        
    } else {
        DLOG("favs were NOT LOADED");        
    }
    
    NSString *pathBookmarked = [documentsDir stringByAppendingPathComponent:@"Bookmarked"];  
    NSString *jsonB = [[NSString alloc] initWithContentsOfFile:pathBookmarked 
                                                     encoding:NSUnicodeStringEncoding error:&error];
    
    NSArray *bms = [jsonB objectFromJSONString];
    bookmarked_ = [self extractFromJsonArray:bms];
    
    if (bookmarked_ != nil && success) {
        success = YES;
//        DLOG("book LOADED: %d", [bookmarked_ count]);        
    } else {
        success = NO;
        DLOG("book NOT LOADED");
    }
        
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
    [self saveFavourites];
    [self saveBookmarked];
}

- (void)saveFavourites
{
    NSArray *pathDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                           NSUserDomainMask,  
                                                           YES);
    NSString *documentsDir = [pathDir objectAtIndex:0];
    NSString *pathFavourites = [documentsDir stringByAppendingPathComponent:@"Favourites"];    
    
    NSArray *converted = [self convertToJsonArray:favourites_]; 
    NSString *JSON = [converted JSONString];    

    NSError *error;
    BOOL success = [JSON writeToFile:pathFavourites atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    
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
