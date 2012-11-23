#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TVShow.h"

#define STATUS_NEEDS_UPDATE @"status: needs update"
#define STATUS_UPDATING @"status: updating"
#define STATUS_UPDATED @"status: updated"

@interface MySeries : NSObject

@property (nonatomic, strong) NSMutableArray *favourites;
@property (nonatomic, strong) NSMutableArray *bookmarked;
@property (nonatomic, strong) NSString *status;

- (BOOL)addToFavorites:(TVShow *)show;
- (void)removeFromFavorites:(TVShow *)show;

- (BOOL)rememberShow:(TVShow *)show;
- (void)forgetShow:(TVShow *)show;

- (BOOL)load;
- (void)save;
- (void)update;

- (void)setNotificationsEnabled:(BOOL)enabled;

- (void)mergeFavouritesWith:(NSArray *)newFavs;

- (NSArray *)downloadSeriesWithId:(NSString *)seriesId;
- (NSArray *)downloadSeriesSyncWithId:(NSString *)seriesId;

@end
