#import "MySeries.h"
#import "TabSwitcher.h"

@class TVShow;

@interface ShowVC: UIViewController
{
    __unsafe_unretained id<TabSwitcher> switcher;
}

@property (unsafe_unretained) id<TabSwitcher> switcher;
@property (nonatomic, strong) MySeries *myseries;
@property (nonatomic, assign) BOOL searchTab;

- (void)setShow:(TVShow *)show;

@end