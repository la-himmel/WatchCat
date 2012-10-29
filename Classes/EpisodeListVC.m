#import "EpisodeListVC.h"
#import "EpisodeCell.h"
#import "ScheduleCell.h"
#import "UIView+position.h"
#import "utils.h"
#import "EpisodeVC.h"
#import "SeasonCell.h"

@interface EpisodeListVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView_;
    NSArray *episodes_; 
    NSMutableArray *sections_;

    TVShow *show_;

    NSInteger currentSeason_;
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

    currentSeason_ = -1;
    
    return self;
}

- (BOOL)theOnlySeason
{
    Episode *first = [episodes_ objectAtIndex:0];
    Episode *last = [episodes_ objectAtIndex:([episodes_ count] -1)];
    
    return first.seasonNum == last.seasonNum;
}

- (void)sortItems
{
    sections_ = [[NSMutableArray alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    
    int counter = 0;
    BOOL lastEpisode = NO;
    
    int currentSeason = -1;
    
    for (Episode *episode in episodes_) {
        counter++;
        
        if (counter == [episodes_ count]) {
            lastEpisode = YES;
        }
                    
        if (currentSeason < 0) {
            currentSeason = episode.seasonNum;
        }
        //initial season
        
        if (currentSeason != episode.seasonNum || lastEpisode) {

            if (lastEpisode) {
                [rows addObject:episode];
            }
            //the last episode in the list

            currentSeason = episode.seasonNum;
            
            [sections_ addObject:rows];
            rows = nil;
            
            if (!lastEpisode) {
                rows = [[NSMutableArray alloc] init];
                [rows addObject:episode];
            }
            
        } else {
            [rows addObject:episode];
        }        
    }
    if ([self theOnlySeason]) {
        currentSeason_ = 0;
    }
        

    DLOG("array: %d", [sections_ count]);
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
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
        
        [self sortItems];
        
        [tableView_ reloadData];
        [tableView_ setNeedsDisplay];
        [spinner_ stopAnimating];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentSeason_ == section)
        return 1 + [[sections_ objectAtIndex:section] count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = [sections_ objectAtIndex:(NSUInteger)indexPath.section];
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        Episode *firstEpisode = [rows objectAtIndex:1];
        
        NSString *season = [NSString stringWithFormat:@"Season %d", firstEpisode.seasonNum];
        
        static NSString *MyTitleId = @"someTitleId";
        SeasonCell *tvCell = [tableView dequeueReusableCellWithIdentifier:MyTitleId];
        
        if (tvCell == nil) {
            tvCell = [[SeasonCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:MyTitleId];
        }
        
        [tvCell setTitle:season];
        cell = tvCell;

    } else {
       
        Episode *episode = [rows objectAtIndex:((NSUInteger)indexPath.row -1)];
        
        static NSString *MyIdentifier = @"someIdentifier";
        EpisodeCell *eCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (eCell == nil) {
            eCell = [[EpisodeCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:MyIdentifier];
        }
        
        [eCell setEpisode:episode];
        cell = eCell;
    }
            
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
    if (currentSeason_ < 0) {
        //open this section

        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSArray *rows = [sections_ objectAtIndex:indexPath.section];
        
        for (int i = 0; i < [rows count]; i++) {
            NSIndexPath *indexPathToAdd = [NSIndexPath indexPathForRow:(i +1)
                                                        inSection:indexPath.section];
            [indexPaths addObject:indexPathToAdd];
        }
        
        currentSeason_ = indexPath.section;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
    } else if (currentSeason_ == indexPath.section) {
        //show episode
        
        if (indexPath.row) {
            NSArray *rows = [sections_ objectAtIndex:indexPath.section];
            Episode *episode = [rows objectAtIndex:(indexPath.row -1)];
            EpisodeVC *vc = [[EpisodeVC alloc] init];
            vc.episode = episode;
            
//            [[self navigationController] setNavigationBarHidden:NO];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            NSArray *rowsToDelete = [sections_ objectAtIndex:currentSeason_];
            for (int i = 0; i < [rowsToDelete count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i +1)
                                                            inSection:currentSeason_];
                [indexPathsToDelete addObject:indexPath];
            }
            
            currentSeason_ = -1;
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
                        
        }
        
    } else {
        //close current section and open this one
        DLOG("switch season");
        
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        NSArray *rowsToDelete = [sections_ objectAtIndex:currentSeason_];
        for (int i = 0; i < [rowsToDelete count]; i++) {
            NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:(i +1)
                                                        inSection:currentSeason_];
            [indexPathsToDelete addObject:indexPathToDelete];
        }
        
        currentSeason_ = -1;
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        NSMutableArray *indexPathsToAdd = [[NSMutableArray alloc] init];
        NSArray *rowsToAdd = [sections_ objectAtIndex:indexPath.section];
        for (int i = 0; i < [rowsToAdd count]; i++) {
            NSIndexPath *indexPathToAdd = [NSIndexPath indexPathForRow:(i +1)
                                                        inSection:indexPath.section];
            [indexPathsToAdd addObject:indexPathToAdd];
        }
        
        currentSeason_ = indexPath.section;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

@end
