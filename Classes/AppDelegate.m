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
    
    scheduleVC_ = [[ScheduleVC alloc] initWithItems:series_.favourites];        
    [scheduleVC_ setMyseries:series_];
    
    ScheduleVC *bvc = [[ScheduleVC alloc] initWithItems:series_.bookmarked];        
    [bvc setMyseries:series_];
    
    searchVC_ = [[SearchVC alloc] init];
    searchVC_.myseries = series_;

    UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController:searchVC_];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.image = [UIImage imageNamed:@"navbar"];  
    
    [searchNC.navigationBar addSubview:view];    
    [searchNC setNavigationBarHidden:YES];
    searchNC.delegate = self;

    UIImageView *scheduleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    scheduleView.image = [UIImage imageNamed:@"navbar"]; 
    
    UINavigationController *favouritesNC = [[UINavigationController alloc] initWithRootViewController:scheduleVC_];
    [favouritesNC.navigationBar addSubview:scheduleView];

    UIImageView *settingsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    settingsView.image = [UIImage imageNamed:@"navbar"]; 
        
    SettingsVC *settingsVC = [[SettingsVC alloc] init]; 
    
    UINavigationController *settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [settingsNC.navigationBar addSubview:settingsView];
    
    UIImageView *bmView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bmView.image = [UIImage imageNamed:@"navbar"]; 
    
    UINavigationController *bookmarkedNC = [[UINavigationController alloc] initWithRootViewController:bvc];
    [bookmarkedNC.navigationBar addSubview:bmView];
    
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

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(searchVC_ == viewController) {
        [navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [navigationController setNavigationBarHidden:NO animated:NO];
    }
}

@end


