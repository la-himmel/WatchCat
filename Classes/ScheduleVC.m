#import "ScheduleVC.h"
#import "ShowCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "ShowVC.h"
#import "utils.h"

@interface ScheduleVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
    NSMutableArray *favourites_;
    
    UIImageView *back_;
    UILabel *msg_;

}
@end

@implementation ScheduleVC

@synthesize myseries = myseries_;
@synthesize switcher = switcher_;

- (id)initWithItems:(NSMutableArray *)items
{
    if (!(self = [super init])) {
        return nil;
    }
    
    favourites_ = items;
        
    return self;
}

- (void)setMyseries:(MySeries *)myseries
{
    myseries_ = myseries;    
    
    [tableView_ reloadData];
    [tableView_ setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView_ reloadData];
    [self adjust];
    [tableView_ setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;

    back_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];   
    
    NSString *imageName = @"surpriseBr";
    if ([favourites_ count] == 0) {
        imageName = @"mainClouds";
    } else if ([favourites_ count] < 6) {
        imageName = @"main20";
    } 
    
    tableView_.backgroundView = back_;
    tableView_.rowHeight = [ScheduleCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView_.backgroundColor = [UIColor redColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.view addSubview:tableView_];  
    
    msg_ = [[UILabel alloc] initWithFrame:CGRectMake(28, 
                                                     107, 
                                                     320, 
                                                     25)];
    msg_.backgroundColor = [UIColor clearColor];
    msg_.textColor = [UIColor colorWithRed:0x92/255.0 green:0x88/255.0 blue:0x96/255.0 alpha:0.9];
    msg_.textAlignment = UITextAlignmentLeft;
    [msg_ setFont:[UIFont fontWithName:@"Arial" size:15]];
    if ([favourites_ count] == 0) {
        msg_.text = @"No series yet";
        [self.view addSubview:msg_];
    } else {
        [msg_ removeFromSuperview];
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(switchEditMode)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)switchEditMode
{
    NSString *title;
    
    BOOL editing = !tableView_.editing;
    if (editing) {
        title = [[NSString alloc] initWithString:@"Done"];
    } else {
        title = [[NSString alloc] initWithString:@"Edit"];
    }
    
    self.navigationItem.rightBarButtonItem.title = title;
    [tableView_ setEditing:editing animated:YES];
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

- (void)adjust
{
    tableView_.bounces = ([favourites_ count] >= 6); 

    
    NSString *imageName = @"surpriseBr";
    if ([favourites_ count] == 0) {
        imageName = @"mainClouds";
    } else if ([favourites_ count] < 6) {
        imageName = @"main20";
    } 
    
    back_.image = [UIImage imageNamed:imageName];
    tableView_.backgroundView = back_;
    
    if ([favourites_ count] == 0) {
        msg_.text = @"No series yet";
        [self.view addSubview:msg_];
    } else {
        [msg_ removeFromSuperview];
    }
    
    [msg_ setNeedsDisplay];
    [tableView_.backgroundView setNeedsDisplay];
    [tableView_ setNeedsDisplay];  
    
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
    
    NSArray *backs = [[NSArray alloc] initWithObjects:@"main1", @"main2",
                      @"main3", @"main4", @"main5", @"main6", nil];
    
    NSString *name = [backs objectAtIndex:(indexPath.row %6)];
    
    if ([favourites_ count] < 6) {
        name = @"placeholder.png";
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:name] 
                                                              stretchableImageWithLeftCapWidth:0.0 
                                                              topCapHeight:5.0]];  
    cell.selectedBackgroundView = [[UIImageView alloc] 
                                   initWithImage:[[UIImage imageNamed:name] 
                                                  stretchableImageWithLeftCapWidth:0.0 
                                                  topCapHeight:5.0]];

    [self adjust];
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