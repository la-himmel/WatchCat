#import "TabSwitcher.h"

@interface TabbarVC: UIViewController<TabSwitcher>

- (id)initWithViewControllers:(NSArray *)vcs;
- (void)switchTabTo:(int)index;
- (int)currentTab;

- (void)pushViewController:(UIViewController *)vc tab:(int)tabId;
- (int)currentTab;
- (void)goToRootAndRefreshTab:(int)tabId;

@end
