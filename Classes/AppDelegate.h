#import <UIKit/UIKit.h>
#import "TabSwitcher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, 
  TabSwitcher>

@property (strong, nonatomic) UIWindow *window;

- (void)pushViewController:(UIViewController *)vc tab:(int)tabId;
@end
