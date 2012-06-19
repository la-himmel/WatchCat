#import "AppDelegate.h"
#import "utils.h"
#import "SearchVC.h"
#import "ScheduleVC.h"
#import "TabbarVC.h"
#import "CustomNavigationBar.h"
#import "SettingsVC.h"

@interface AppDelegate()
{
    UINavigationController *nc_;
}
@end

@implementation AppDelegate

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    nc_ = [[UINavigationController alloc] 
                                  initWithRootViewController:[[/*SearchVC*/SettingsVC alloc] init]];

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.image = [UIImage imageNamed:@"navbar@2x.png"];    
    [nc_.navigationBar addSubview:view];
    
//    [nc_ setNavigationBarHidden:YES];
    nc_.delegate = self;

//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];  
//    UIImage *backImage = [UIImage imageNamed:@"backButton@2x.png"];  
//    [back setImage:backImage forState:UIControlStateNormal];  
//    
//    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];  
//    back.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);  
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];                               
//    [nc_.navigationItem setLeftBarButtonItem:backButton];
    
    NSArray *vcs = [NSArray arrayWithObjects:
        [[ScheduleVC alloc] init],
        nc_,
        [[SettingsVC alloc] init],
        [[UIViewController alloc] init],
        nil];

    self.window.rootViewController = [[TabbarVC alloc] initWithViewControllers:vcs];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if([navigationController.viewControllers objectAtIndex:0] == viewController) {
//        [navigationController setNavigationBarHidden:YES animated:NO];
//    }
}

//- (void)goback
//{
//    [nc_ popViewControllerAnimated:YES];
//}

@end


