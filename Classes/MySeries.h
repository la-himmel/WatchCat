#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TVShow.h"

@interface MySeries : NSObject

@property (nonatomic, strong) NSMutableArray *favourites;
@property (nonatomic, strong) NSMutableArray *bookmarked;

- (BOOL)addToFavorites:(TVShow *)show;
- (void)removeFromFavorites:(TVShow *)show;

- (BOOL)rememberShow:(TVShow *)show;
- (void)forgetShow:(TVShow *)show;

- (BOOL)load;
- (void)save;

@end
