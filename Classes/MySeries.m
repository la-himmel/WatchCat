#import "MySeries.h"
#import "utils.h"

@implementation MySeries

@synthesize favourites = favourites_;
@synthesize saved = saved_;

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }    
    favourites_ = [[NSMutableArray alloc] init];
    saved_ = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)load
{
    //test
    TVShow *show4 = [[TVShow alloc] init];
    show4.id = 4;
    show4.name = @"Vampire diaries";
    show4.episodes = [NSArray array];
    
    TVShow *show5 = [[TVShow alloc] init];
    show5.id = 5;
    show5.name = @"Two and a half men";
    show5.episodes = [NSArray array];
    
    TVShow *show6 = [[TVShow alloc] init];
    show6.id = 6;
    show6.name = @"How i met your mother";
    show6.episodes = [NSArray array];
    
    TVShow *show7 = [[TVShow alloc] init];
    show7.id = 7;
    show7.name = @"Daria";
    show7.episodes = [NSArray array];
    
    [favourites_ addObject:show4];
    [favourites_ addObject:show5];
    [favourites_ addObject:show6];
    [favourites_ addObject:show7];
    
    DLOG("nothing to do, favs: %d", [favourites_ count]);
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
}

- (void)removeFromFavorites:(TVShow *)show
{
}

- (void)rememberShow:(TVShow *)show
{
}

- (void)forgetShow:(TVShow *)show
{
}

@end
