#import "BookmarkedVC.h"
#import "ShowCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "ShowVC.h"
#import "utils.h"

@interface BookmarkedVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
    NSMutableArray *bookmarked_;
}
@end

@implementation BookmarkedVC

@synthesize myseries = myseries_;

- (void)viewDidLoad
{
    DLOG("view did load");
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;
    tableView_.rowHeight = [ScheduleCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [self.view addSubview:tableView_];       
    
}

- (void)viewWillAppear:(BOOL)animated
{
    DLOG("%d %d", [bookmarked_ count], [myseries_.bookmarked count]);
    
    [tableView_ reloadData];
    [tableView_ setNeedsDisplay];
}

- (void)setMyseries:(MySeries *)myseries
{
    myseries_ = myseries;    
    bookmarked_ = myseries_.bookmarked;
    
    [tableView_ reloadData];
    [tableView_ setNeedsDisplay];    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [bookmarked_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"someIdentifier";    
    ShowCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[ShowCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                               reuseIdentifier:MyIdentifier];
    }    
    [cell setShow:[bookmarked_ objectAtIndex:indexPath.row]];
    
    NSArray *backs = [[NSArray alloc] initWithObjects:@"main1@2x.png", @"main2@2x.png",
                      @"main3@2x.png", @"main4@2x.png", @"main5@2x.png", @"main6@2x.png", nil];
    
    NSString *name = [backs objectAtIndex:(indexPath.row %6)];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:name] 
                                                              stretchableImageWithLeftCapWidth:0.0 
                                                              topCapHeight:5.0]];  
    cell.selectedBackgroundView = [[UIImageView alloc] 
                                   initWithImage:[[UIImage imageNamed:name] 
                                                  stretchableImageWithLeftCapWidth:0.0 
                                                  topCapHeight:5.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowVC *vc = [[ShowVC alloc] init];
    [vc setShow:[bookmarked_ objectAtIndex:indexPath.row]];
    [vc setMyseries:myseries_];
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

