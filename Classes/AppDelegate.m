#import "AppDelegate.h"
#import "utils.h"
#import "SearchVC.h"
#import "ScheduleVC.h"
#import "TabbarVC.h"

@implementation AppDelegate

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationController *nc = [[UINavigationController alloc] 
                                  initWithRootViewController:[[SearchVC alloc] init]];
    [nc setNavigationBarHidden:YES];
    nc.delegate = self;
        
    NSArray *vcs = [NSArray arrayWithObjects:
        [[ScheduleVC alloc] init],
        nc,
        [[UIViewController alloc] init],
        [[UIViewController alloc] init],
        nil];

    self.window.rootViewController = [[TabbarVC alloc] initWithViewControllers:vcs];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController.viewControllers objectAtIndex:0] == viewController) {
        [navigationController setNavigationBarHidden:YES animated:NO];
    }
}

@end

