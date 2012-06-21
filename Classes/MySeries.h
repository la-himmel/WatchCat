#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TVShow.h"

@interface MySeries : NSObject

@property (nonatomic, strong) NSMutableArray *favourites;
@property (nonatomic, strong) NSMutableArray *bookmarked;

- (void)addToFavorites:(TVShow *)show;
- (void)removeFromFavorites:(TVShow *)show;

- (void)rememberShow:(TVShow *)show;
- (void)forgetShow:(TVShow *)show;

- (BOOL)load;
- (void)save;

@end
