#import "ScheduleVC.h"
#import "ShowCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "ShowVC.h"
#import "utils.h"
#import "UIBarButtonItem+CustomImage.h"

@interface ScheduleVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
    NSMutableArray *favourites_;
    
    UIImageView *back_;
    UILabel *msg_;
    
    BOOL editing_;
    BOOL emptyOrSmall_;
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIBarButtonItem *backBarItemActive;
@property (nonatomic, strong) UIBarButtonItem *backBarItem;
@end

@implementation ScheduleVC

@synthesize myseries = myseries_;
@synthesize switcher = switcher_;
@synthesize spinner = spinner_;
@synthesize backBarItem = backBarItem_;
@synthesize backBarItemActive = backBarItemActive_;
@synthesize isAFavouritesList = isAFavouritesList_;

- (id)initWithItems:(NSMutableArray *)items
{
    DLOG("");
    editing_ = NO;
    if (!(self = [super init])) {
        return nil;
    }
    
    favourites_ = items;
    emptyOrSmall_ = YES;
        
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
    
    NSString *imageName = @"surprise_double";
    if ([favourites_ count] == 0) {
        imageName = @"mainClouds";
    } else if ([favourites_ count] < 6) {
        imageName = @"main20";
    } 
    
    tableView_.backgroundView = back_;
    tableView_.rowHeight = [ScheduleCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView_];
    
    msg_ = [[UILabel alloc] initWithFrame:CGRectMake(28, 107, 320, 25)];
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
    
    backBarItem_ = [[UIBarButtonItem alloc]
                    initWithTitle:@""
                    backgroundImage:[UIImage imageNamed:@"edit2"]
                    backgroundHighlightedImage:[UIImage imageNamed:@"edit2"]
                    target:self
                    action:@selector(switchEditMode)];
    
    backBarItemActive_ = [[UIBarButtonItem alloc]
                    initWithTitle:@""
                    backgroundImage:[UIImage imageNamed:@"edit2_active"]
                    backgroundHighlightedImage:[UIImage imageNamed:@"edit2_active"]
                    target:self
                    action:@selector(switchEditMode)];
    
    self.navigationItem.rightBarButtonItem = backBarItem_;
    
//    DLOG("ScheduleVC, table.view; view: %@ %@", NSStringFromCGRect(tableView_.frame),
//         NSStringFromCGRect(self.view.frame));
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        DLOG("KVO status: %@", myseries_.status);
        
        if (myseries_.status == STATUS_UPDATED) {
            [myseries_ mergeFavouritesWith:favourites_];
            [myseries_ removeObserver:self forKeyPath:@"status"];
            favourites_ = myseries_.favourites;
            //then link favs to myseries items
            //aaand save
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)switchEditMode
{
    editing_ = !tableView_.editing;
    if (editing_) {
        self.navigationItem.rightBarButtonItem = backBarItemActive_;
    } else {
        self.navigationItem.rightBarButtonItem = backBarItem_;
    }

    [tableView_ setEditing:editing_ animated:YES];
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
//    if ([favourites_ count] < 7) {
//        DLOG("empty or small!");
//        return 7;
//    }
//    
//    DLOG("not small");
    return [favourites_ count];
}

- (void)adjust
{
    tableView_.bounces = ([favourites_ count] >= 6); 

    
    NSString *imageName = @"surprise_double";
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
    spinner_ = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner_ startAnimating];
    
    CGRect sp = CGRectMake((tableView_.frame.size.width - spinner_.frame.size.width) /2,
                           (tableView_.frame.size.height - spinner_.frame.size.height) /2,
                           spinner_.frame.size.width,
                           spinner_.frame.size.height);
    
    [spinner_ setFrame:sp];
    [self.view addSubview:spinner_];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{
        ShowVC *vc = [[ShowVC alloc] init];
        [vc setShow:[favourites_ objectAtIndex:indexPath.row]];
        [vc setMyseries:myseries_];
        [vc setSwitcher:switcher_];
        
        vc.isAFavouriteShow = self.isAFavouritesList;
        vc.isABookmarkedShow = !self.isAFavouritesList;
        
//        DLOG("favourite: %@", vc.isAFavouriteShow ? @"yes" : @"no");
//        DLOG("bookmarked: %@", vc.isABookmarkedShow ? @"yes" : @"no");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
            [spinner_ stopAnimating];
        });
    });
    
}


@end