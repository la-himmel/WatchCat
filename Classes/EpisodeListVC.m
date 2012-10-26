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
    NSMutableArray *emptySections_;
    
    NSMutableArray *dataSource_;
    
    TVShow *show_;
    BOOL severalSeasons_;
    NSInteger currentSeason_;

    UIImageView *back_; 
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

const NSString *ROW_KEY = @"rows";

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
    
    emptySections_ = [[NSMutableArray alloc] init];
    dataSource_ = [[NSMutableArray alloc] init];
    
    currentSeason_ = -1;
    
    return self;
}

- (void)createEmptySections
{
    for (NSDictionary *dict in sections_) {
        NSArray *rows = [dict objectForKey:ROW_KEY];
        Episode *episode = [rows objectAtIndex:1];
        //0 element is always season title, so first episode is 1
        
        NSString *season = [NSString stringWithFormat:@"Season %d", episode.seasonNum];
        NSArray *array = [[NSArray alloc] initWithObjects:season, nil];
        
        NSMutableDictionary *section = [[NSMutableDictionary alloc] init];
        [section setObject:array forKey:ROW_KEY];
        
        [emptySections_ addObject:section];
        [dataSource_ addObject:section];
    }
}

- (void)sortItems
{
    int firstSeason = -1;
    BOOL needToSort = NO;
    
    for (Episode *episode in episodes_) {
        if (firstSeason < 0)
            firstSeason = episode.seasonNum;
        else if (firstSeason != episode.seasonNum) {
            needToSort = YES;
            severalSeasons_ = YES;
            break;
        }
    }
    
    
    sections_ = [[NSMutableArray alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    
    int counter = 0;
    BOOL lastEpisode = NO;
    
    int currentSeason = -1;
    if (needToSort) {
        for (Episode *episode in episodes_) {
            counter++;
            if (counter == [episodes_ count])
                lastEpisode = YES;
                        
            if (currentSeason < 0)
                currentSeason = episode.seasonNum;
            //initial season
            
            if (currentSeason != episode.seasonNum || lastEpisode) {

                if (lastEpisode) {
                    [rows addObject:episode];
                }
                //the last episode in the list

                DLOG("small array %d, season: %d", [rows count], currentSeason);
                currentSeason = episode.seasonNum;
                
                NSMutableDictionary *section = [[NSMutableDictionary alloc] init];
                [section setObject:rows forKey:ROW_KEY];
                [sections_ addObject:section];
                //push this array, because this is the next season
                
                rows = nil;
                //clear array after pushing
                
                if (!lastEpisode) {
                    rows = [[NSMutableArray alloc] init];
                    
                    NSString *season = [NSString stringWithFormat:@"Season %d", episode.seasonNum];

                    [rows addObject:season];
                    [rows addObject:episode];
                }
                
            } else {
                [rows addObject:episode];
            }        
        }
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
        
        severalSeasons_ = NO;
        [self sortItems];
        [self createEmptySections];
        
        [tableView_ reloadData];
        [tableView_ setNeedsDisplay];
        [spinner_ stopAnimating];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections_ count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataSource_ objectAtIndex:section] objectForKey:ROW_KEY] count];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    view.backgroundColor = [UIColor purpleColor];
//    return view;    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = [dataSource_ objectAtIndex:(NSUInteger)indexPath.section];
    NSArray *rows = [section objectForKey:ROW_KEY];
    
    DLOG("section: %d", indexPath.section);
    DLOG("current season: %d", currentSeason_);
    UITableViewCell *cell = nil;
    
    NSObject *season = [rows objectAtIndex:(NSUInteger)indexPath.row];
    
    if ([season isKindOfClass:[NSString class]]) {
        DLOG("this is string season");
        
        NSString *season = [rows objectAtIndex:(NSUInteger)indexPath.row];
        
        static NSString *MyTitleId = @"someTitleId";
        SeasonCell *tvCell = [tableView dequeueReusableCellWithIdentifier:MyTitleId];
        
        if (tvCell == nil) {
            tvCell = [[SeasonCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:MyTitleId];
        }
        
        [tvCell setTitle:season];
        cell = tvCell;

    } else if ([season isKindOfClass:[Episode class]]) {
        DLOG("this is episode");
        
        Episode *episode = [rows objectAtIndex:(NSUInteger)indexPath.row];
        
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
    NSDictionary *section = [dataSource_ objectAtIndex:indexPath.section];
    NSArray *rows = [section objectForKey:ROW_KEY];
    
    if (currentSeason_ < 0) {
        //open this section
        DLOG("no season");

        currentSeason_ = indexPath.section;
        NSDictionary *section = [sections_ objectAtIndex:indexPath.section];
        [dataSource_ replaceObjectAtIndex:indexPath.section withObject:section];
        [tableView reloadData];
        
    } else if (currentSeason_ == indexPath.section) {
        //show episode
        DLOG("season opened");
        
        if (indexPath.row) {
            Episode *episode = [rows objectAtIndex:indexPath.row];
            EpisodeVC *vc = [[EpisodeVC alloc] init];
            vc.episode = episode;
            
            [[self navigationController] setNavigationBarHidden:NO];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSDictionary *emptysection = [emptySections_ objectAtIndex:currentSeason_];
            [dataSource_ replaceObjectAtIndex:currentSeason_ withObject:emptysection];
            
            currentSeason_ = -1;
            [tableView reloadData];
        }
        
    } else {
        //close current section and open this one
        DLOG("switch season");

        NSDictionary *section = [sections_ objectAtIndex:indexPath.section];
        [dataSource_ replaceObjectAtIndex:indexPath.section withObject:section];
        
        NSDictionary *emptysection = [emptySections_ objectAtIndex:currentSeason_];
        [dataSource_ replaceObjectAtIndex:currentSeason_ withObject:emptysection];
        
        currentSeason_ = indexPath.section;
        [tableView reloadData];
    }
    
}

@end
