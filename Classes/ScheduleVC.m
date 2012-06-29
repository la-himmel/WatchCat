#import "ScheduleVC.h"
#import "ShowCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "ShowVC.h"
#import "utils.h"

@interface ScheduleVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITableView *tableView_;
    NSMutableArray *favourites_;
    
    BOOL tapped;
}
@end

@implementation ScheduleVC

@synthesize myseries = myseries_;
@synthesize switcher = switcher_;

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    tapped = NO;
    
    return self;
}

- (void)setMyseries:(MySeries *)myseries
{
    myseries_ = myseries;    
    favourites_ = myseries_.favourites;
    
    [tableView_ reloadData];
    [tableView_ setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLOG("view vill appear %d %d", [favourites_ count], [myseries_.favourites count]);
    
    [tableView_ reloadData];
    [tableView_ setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;
    tableView_.rowHeight = [ScheduleCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; 
    lpgr.delegate = self;
    [tableView_ addGestureRecognizer:lpgr];

    [self.view addSubview:tableView_];       
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (!tapped) {
        [tableView_ setEditing:!tableView_.editing animated:YES];
        tapped = YES;
    } else {
        DLOG("hundred other taps");
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    { 
        [favourites_ removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [tableView_ reloadData];
    }
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [favourites_ count];
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
    [cell setShow:[favourites_ objectAtIndex:indexPath.row]];
    
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
    if ([favourites_ count] <= 6) {
        tableView_.bounces = NO;        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowVC *vc = [[ShowVC alloc] init];
    [vc setShow:[favourites_ objectAtIndex:indexPath.row]];
    [vc setMyseries:myseries_];
    [vc setSwitcher:switcher_];
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
}
@end