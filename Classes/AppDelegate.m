#import "AppDelegate.h"
#import "utils.h"
#import "SearchVC.h"
#import "ScheduleVC.h"
#import "TabbarVC.h"
//#import "CustomNavigationBar.h"
#import "SettingsVC.h"
#import "MySeries.h"
//#import "AdvancedNavigationBar.h"

@interface AppDelegate()
{   
    ScheduleVC *scheduleVC_;
    SearchVC *searchVC_;
    
    NSArray *vcs_;
    
    NSString *serverTime;
    
    TabbarVC *tabbarVC_;
    
    MySeries *series_;
}
@end

@implementation AppDelegate

@synthesize window = window_;


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    serverTime = @"1340708900";
    //TODO: save in user defaults or smth. First launch: go and save server time somewhere
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    series_ = [[MySeries alloc] init];
    [series_ load];
    
    [series_ update];
    
    //search NC & VC - tab 2
    searchVC_ = [[SearchVC alloc] init];
    searchVC_.myseries = series_;

    UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController:searchVC_];    
    [searchNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [searchNC setNavigationBarHidden:YES];
    searchNC.delegate = self;
    
    //favourites NC - tab 1
    scheduleVC_ = [[ScheduleVC alloc] initWithItems:series_.favourites];
    [scheduleVC_ setMyseries:series_];
    
    UINavigationController *favouritesNC = [[UINavigationController alloc] initWithRootViewController:scheduleVC_];
    [favouritesNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    //settings VC & NC - tab 3
    SettingsVC *settingsVC = [[SettingsVC alloc] init];
    [settingsVC setMyseries:series_];
    
    UINavigationController *settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [settingsNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
   
    //bookmarked VC & NC - tab 4
    ScheduleVC *bvc = [[ScheduleVC alloc] initWithItems:series_.bookmarked];
    [bvc setMyseries:series_];
    
    UINavigationController *bookmarkedNC = [[UINavigationController alloc] initWithRootViewController:bvc];
    [bookmarkedNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    vcs_ = [NSArray arrayWithObjects:
        favouritesNC,
        searchNC,
        settingsNC,
        bookmarkedNC,
        nil];

    tabbarVC_ = [[TabbarVC alloc] initWithViewControllers:vcs_];
    
    searchVC_.switcher = tabbarVC_;
    self.window.rootViewController = tabbarVC_;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [series_ save];    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLOG("app will enter foreground");
    
    [series_ load];
    DLOG("loaded");
    
    [series_ update];
    DLOG("update");
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (searchVC_ == viewController) {
        [navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [navigationController setNavigationBarHidden:NO animated:NO];
    }
}

@end


