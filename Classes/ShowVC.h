#import "MySeries.h"
#import "TabSwitcher.h"

@class TVShow;

@interface ShowVC: UIViewController<UIAlertViewDelegate, UIScrollViewDelegate>
{
    __unsafe_unretained id<TabSwitcher> switcher;
}

@property (unsafe_unretained) id<TabSwitcher> switcher;
@property (nonatomic, strong) MySeries *myseries;

- (void)setShow:(TVShow *)show;

@end 