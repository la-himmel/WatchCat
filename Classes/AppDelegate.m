#import "AppDelegate.h"

#import "SearchVC.h"
#import "TabbarVC.h"

@implementation AppDelegate

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    NSArray *vcs = [NSArray arrayWithObjects:
        [[UIViewController alloc] init],
        [[SearchVC alloc] init],
        [[UIViewController alloc] init],
        [[UIViewController alloc] init],
        nil];

    self.window.rootViewController = [[TabbarVC alloc] initWithViewControllers:vcs];

    [self.window makeKeyAndVisible];

    return YES;
}

@end
