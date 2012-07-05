#import "EpisodeListVC.h"
#import "EpisodeCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "utils.h"
#import "EpisodeVC.h"

@interface EpisodeListVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
    NSArray *episodes_;
    TVShow *show_;

    UIImageView *back_; 
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;   
@end

@implementation EpisodeListVC
@synthesize spinner = spinner_;
@synthesize myseries = myseries_;

- (id)initWithItems:(NSArray *)items
{
    if (!(self = [super init])) {
        return nil;
    }
    
    episodes_ = items;    
    return self;
}

- (id)initWithShow:(TVShow *)show
{
    if (!(self = [super init])) {
        return nil;
    }    
    show_ = show;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.delegate = self;
    
    back_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];   
    
    tableView_.backgroundView = back_;
    tableView_.rowHeight = [ScheduleCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.view addSubview:tableView_];          
    
    
    if ([episodes_ count] == 0) {
        spinner_ = [[UIActivityIndicatorView alloc] 
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner_ startAnimating];
        
        CGRect sp = CGRectMake((tableView_.frame.size.width - spinner_.frame.size.width) /2, 
                               (self.view.height - 44 - 54 - spinner_.frame.size.height) /2, 
                               spinner_.frame.size.width, 
                               spinner_.frame.size.height);
        [spinner_ setFrame:sp];
        [tableView_ addSubview:spinner_];
        
        episodes_ = [myseries_ downloadSeriesSyncWithId:show_.idString];
        
        DLOG("Loaded: count %d", [episodes_ count]);
        
        [tableView_ reloadData];
        [tableView_ setNeedsDisplay];
        [spinner_ stopAnimating];
    }
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [episodes_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"someIdentifier";    
    EpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[EpisodeCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                               reuseIdentifier:MyIdentifier];
    }    
    [cell setEpisode:[episodes_ objectAtIndex:indexPath.row]];
    
    NSArray *backs = [[NSArray alloc] initWithObjects:@"episodes1", @"episodes2",
                      @"episodes3", @"episodes4", @"episodes5", @"episodes6", nil];
    
    NSString *name = [backs objectAtIndex:(indexPath.row %6)];
    
    if ([episodes_ count] < 6) {
        name = @"placeholder.png";
    }
    
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
    Episode *episode = [episodes_ objectAtIndex:indexPath.row];
    EpisodeVC *vc = [[EpisodeVC alloc] init];
    vc.episode = episode;
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
