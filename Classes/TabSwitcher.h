#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TabSwitcher <NSObject>
- (void)pushViewController:(UIViewController *)vc tab:(int)tabId;
@end
