#import "MySeries.h"

@class TVShow;

@interface ShowVC: UIViewController

@property (nonatomic, strong) MySeries *myseries;
- (void)setShow:(TVShow *)show;

@end