#import "SearchVC.h"

#import "SearchCell.h"
#import "ShowCell.h"
#import "utils.h"
#import "UIView+position.h"
#import "TVShow.h"
#import "XMLDeserialization.h"

@interface SearchVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UISearchBar *searchBar_;
    UITableView *tableView_;

    // current search results
    NSArray *filteredShows_;
}
@end

@implementation SearchVC

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    TVShow *show1 = [[TVShow alloc] init];
    show1.id = 1;
    show1.name = @"Castle";
    show1.episodes = [NSArray array];

    TVShow *show2 = [[TVShow alloc] init];
    show2.id = 2;
    show2.name = @"Dollhouse";
    show2.episodes = [NSArray array];

    TVShow *show3 = [[TVShow alloc] init];
    show3.id = 3;
    show3.name = @"Firefly";
    show3.episodes = [NSArray array];

    filteredShows_ = [NSArray arrayWithObjects:show1, show2, show3, nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar_.delegate = self;
    [self.view addSubview:searchBar_];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];
    tableView_.dataSource = self;
    tableView_.delegate = self;
    tableView_.rowHeight = [ShowCell height];
    [self.view addSubview:tableView_];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG("indexPath = %@", indexPath);

    ShowCell *cell = [[ShowCell alloc] init];
    [cell setShow:[filteredShows_ objectAtIndex:indexPath.row]];
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [filteredShows_ count];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLOG("searchBar.text = %@", searchBar.text);

    NSURL *url = [NSURL URLWithString:[NSString
                     stringWithFormat:@"http://services.tvrage.com/feeds/search.php?show=%@",
                                        searchBar.text]];

    NSData *xmlData = [NSData dataWithContentsOfURL:url];

    filteredShows_ = parseSearchResults(xmlData);

    [tableView_ reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    DLOG("");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar_ resignFirstResponder];
}

@end
