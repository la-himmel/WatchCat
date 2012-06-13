#import "ScheduleVC.h"

#import "ScheduleCell.h"
#import "UIView+position.h"

@interface ScheduleVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
}
@end

@implementation ScheduleVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;
    tableView_.rowHeight = [ScheduleCell height];
    [self.view addSubview:tableView_];
}


- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return 0;
}

@end