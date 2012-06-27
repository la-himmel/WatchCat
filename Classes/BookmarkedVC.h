#import "TVShow.h"
#import "MySeries.h"
#import "TabSwitcher.h"

@interface BookmarkedVC : UIViewController
{
    __unsafe_unretained id<TabSwitcher> switcher;
}

@property (unsafe_unretained) id<TabSwitcher> switcher;
@property (nonatomic, strong) MySeries *myseries;
@end





