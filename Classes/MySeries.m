#import "MySeries.h"
#import "utils.h"
#import "JSONKit.h"

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

- (void)loadTestBookMarked
{
    TVShow *show7 = [[TVShow alloc] init];
    show7.num = 7;
    show7.name = @"Daria";
    
    [bookmarked_ addObject:show7];
}

- (BOOL)load
{
    DLOG("loading everything");
    
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
        if (favourites_ != nil) {
            DLOG("loaded f COUNT %d", [favourites_ count]);    
        } else {
           DLOG("NOT LOADED"); 
           return NO;
        } 
    } else if (stringPath == PATH_BOOKMARKED) {
        bookmarked_ = [self extractFromJsonArray:items];  
        if (bookmarked_ != nil) {
            DLOG("loaded f COUNT %d", [bookmarked_ count]);    
        } else {
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
    
    DLOG("Array :: %d", [converted count]);
    
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
        [self saveFavourites];
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
        [self saveBookmarked];
    }
}

- (void)removeFromFavorites:(TVShow *)show
{
    for (TVShow* show_ in favourites_) {
        if ([show isEqual:show_]) {
            [favourites_ removeObject:show_];
            [self saveFavourites];
        }
    }  
}

- (void)forgetShow:(TVShow *)show
{
    for (TVShow* show_ in bookmarked_) {
        if ([show isEqual:show_]) {
            [bookmarked_ removeObject:show_];
            [self saveBookmarked];
        }
    }  
}

@end
