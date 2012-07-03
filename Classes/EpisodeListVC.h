#import <UIKit/UIKit.h>
#import "MySeries.h"
#import "TVShow.h"

@interface EpisodeListVC : UIViewController
- (id)initWithItems:(NSArray *)items;
- (id)initWithShow:(TVShow *)show;

@property (nonatomic, strong) MySeries *myseries;
@end
