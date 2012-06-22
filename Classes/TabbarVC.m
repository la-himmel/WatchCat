#import "TabbarVC.h"
#import "utils.h"
#import "Tabbar.h"
#import "UIView+position.h"

static const CGRect CONTENT_FRAME = {0, 0, 320, 410};
static const int TABBAR_HEIGHT = 50;

typedef enum {
    FavoriteIdx = 0,
    BrowseIdx = 1,
    SettingsIdx = 2,
    TodoIdx = 3
} TabIndex;

@interface TabbarVC ()
{
    UIViewController *favoriteVC_;
    UIViewController *browseVC_;
    UIViewController *settingsVC_;
    UIViewController *todoVC_;

    Tabbar *tabbar_;
}
@end

@implementation TabbarVC

- (id)initWithViewControllers:(NSArray *)vcs;
{
    if (!(self = [super init])) {
        return nil;
    }

    DLOG("init with vc");
    NSAssert([vcs count] == 4, @"There must be 4 tabs");

    favoriteVC_ = [vcs objectAtIndex:0];
    browseVC_ = [vcs objectAtIndex:1];
    settingsVC_ = [vcs objectAtIndex:2];
    todoVC_ = [vcs objectAtIndex:3];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    tabbar_ = [[Tabbar alloc] initWithFrame:(CGRect){0, 0, 320, TABBAR_HEIGHT}];
    tabbar_.bottom = self.view.height;
    tabbar_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:tabbar_];

    [tabbar_ addObserver:self
              forKeyPath:@"selectedIndex"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];

    tabbar_.selectedIndex = 1;
}

- (void)dealloc
{
    [tabbar_ removeObserver:self forKeyPath:@"selectedIndex" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        UIViewController *vc = nil;

        switch ([newValue intValue]) {
            case FavoriteIdx:
                vc = favoriteVC_;
                break;
            case BrowseIdx:
                vc = browseVC_;
                break;
            case SettingsIdx:
                vc = settingsVC_;
                break;
            case TodoIdx:
                DLOG("3");
                vc = todoVC_;
                break;
            default:
                NSAssert(NO, @"Unexpected tab index %@", newValue);
        }

        DLOG("observing value");
        vc.view.frame = CONTENT_FRAME;
        [self.view addSubview:vc.view];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

@end
