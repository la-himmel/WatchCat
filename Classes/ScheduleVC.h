#import "TVShow.h"
#import "MySeries.h"
#import "TabSwitcher.h"

@interface ScheduleVC: UIViewController<UINavigationControllerDelegate>
{
    __unsafe_unretained id<TabSwitcher> switcher;
}

@property (unsafe_unretained) id<TabSwitcher> switcher;
@property (nonatomic, strong) MySeries *myseries;

- (id)initWithItems:(NSMutableArray *)items;

@end