#import "AppDelegate.h"
#import "utils.h"
#import "SearchVC.h"
#import "ScheduleVC.h"
#import "TabbarVC.h"
#import "CustomNavigationBar.h"
#import "SettingsVC.h"
#import "MySeries.h"

@interface AppDelegate()
{
    UINavigationController *nc_;
    ScheduleVC *svc_;
    SearchVC *searchVC_;
    
}
@end

@implementation AppDelegate

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    MySeries *series = [[MySeries alloc] init];
    [series load];
    
    svc_ = [[ScheduleVC alloc] init];        
    [svc_ setMyseries:series];
    
    searchVC_ = [[SearchVC alloc] init];
    searchVC_.myseries = series;
    
    nc_ = [[UINavigationController alloc] initWithRootViewController:searchVC_];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.image = [UIImage imageNamed:@"navbar@2x.png"];  
    
    [nc_.navigationBar addSubview:view];
    
    [nc_ setNavigationBarHidden:YES];
    nc_.delegate = self;

    UIImageView *scheduleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar@2x.png"]];
    UINavigationController *fnc = [[UINavigationController alloc] initWithRootViewController:svc_];
    [fnc.navigationBar addSubview:scheduleView];

    UIImageView *settingsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar@2x.png"]];
    SettingsVC *settingsVC = [[SettingsVC alloc] init];    
    UINavigationController *snc = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [snc.navigationBar addSubview:settingsView];
    
    NSArray *vcs = [NSArray arrayWithObjects:
        fnc,
        nc_,
        snc,
        [[UIViewController alloc] init],
        nil];

    self.window.rootViewController = [[TabbarVC alloc] initWithViewControllers:vcs];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(searchVC_ == viewController) {
        DLOG("--- searchvc ---");
        [navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        DLOG("--- other vc ---");
        [navigationController setNavigationBarHidden:NO animated:NO];
    }
}

@end


