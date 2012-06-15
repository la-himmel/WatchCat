#import "TabbarVC.h"

#import "Tabbar.h"
#import "UIView+position.h"

static const CGRect CONTENT_FRAME = {0, 0, 320, 410};
static const int TABBAR_HEIGHT = 50;

typedef enum {
    FavoriteIdx = 0,
    BrowseIdx = 1,
    TodoIdx = 2,
    SettingsIdx = 3
} TabIndex;

@interface TabbarVC ()
{
    UIViewController *favoriteVC_;
    UIViewController *browseVC_;
    UIViewController *todoVC_;
    UIViewController *settingsVC_;

    Tabbar *tabbar_;
}
@end

@implementation TabbarVC

- (id)initWithViewControllers:(NSArray *)vcs;
{
    if (!(self = [super init])) {
        return nil;
    }

    NSAssert([vcs count] == 4, @"There must be 4 tabs");

    favoriteVC_ = [vcs objectAtIndex:0];
    browseVC_ = [vcs objectAtIndex:1];
    todoVC_ = [vcs objectAtIndex:2];
    settingsVC_ = [vcs objectAtIndex:3];

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
                 context:nil];

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
            case TodoIdx:
                vc = todoVC_;
                break;
            case SettingsIdx:
                vc = settingsVC_;
                break;
            default:
                NSAssert(NO, @"Unexpected tab index %@", newValue);
        }

        vc.view.frame = CONTENT_FRAME;
        [self.view addSubview:vc.view];
    }
}

@end
