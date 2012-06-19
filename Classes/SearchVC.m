#import "SearchVC.h"
#import "ShowVC.h"
#import "SearchCell.h"
#import "ShowCell.h"
#import "utils.h"
#import "UIView+position.h"
#import "TVShow.h"
#import "XMLDeserialization.h"
#import "CustomBarButtonItem.h"

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
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    NSString *longtext = @"Set in Manhattan, How I Met Your Mother follows the social and romantic lives of Ted Mosby and his friends Marshall Eriksen, Robin Scherbatsky, Lily Aldrin and Barney Stinson. As a framing device, the main character, Ted, using voiceover narration by Bob Saget, in the year 2030 recounts to his son and his daughter the events that led to his meeting their mother.";
    
    TVShow *show1 = [[TVShow alloc] init];
    show1.id = 1;
    show1.name = @"Castle";
    show1.episodes = [NSArray array];
    show1.description = [longtext copy];

    TVShow *show2 = [[TVShow alloc] init];
    show2.id = 2;
    show2.name = @"Dollhouse";
    show2.episodes = [NSArray array];
    show2.description = [longtext copy];

    TVShow *show3 = [[TVShow alloc] init];
    show3.id = 3;
    show3.name = @"Firefly";
    show3.episodes = [NSArray array];
    show3.description = [longtext copy];
    
    TVShow *show4 = [[TVShow alloc] init];
    show4.id = 4;
    show4.name = @"Vampire diaries";
    show4.episodes = [NSArray array];
    show4.description = [longtext copy];
    
    TVShow *show5 = [[TVShow alloc] init];
    show5.id = 5;
    show5.name = @"Two and a half men";
    show5.episodes = [NSArray array];
    show5.description = [longtext copy];
    
    TVShow *show6 = [[TVShow alloc] init];
    show6.id = 6;
    show6.name = @"How i met your mother";
    show6.episodes = [NSArray array];
    show6.description = [longtext copy];
    
    TVShow *show7 = [[TVShow alloc] init];
    show7.id = 7;
    show7.name = @"Daria";
    show7.episodes = [NSArray array];

    filteredShows_ = [NSArray arrayWithObjects:show1, show2, show3, show4, show5, show6, show7, nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
    searchBar_.delegate = self;
    [searchBar_ setBackgroundColor:[UIColor clearColor]];
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@"searchNB.png"]];
    
    [searchBar_ setSearchFieldBackgroundImage:[UIImage imageNamed:@"brackets2.png"] 
                                     forState:UIControlStateNormal];
    [searchBar_ setPlaceholder:@"type to search"];
    [searchBar_ setImage:[UIImage imageNamed:@"delete3.png"] forSearchBarIcon:UISearchBarIconClear 
                   state:UIControlStateNormal];
    [searchBar_ setImage:[UIImage imageNamed:@"delete3.png"] forSearchBarIcon:UISearchBarIconClear 
                   state:UIControlStateSelected];
    [searchBar_ setImage:[UIImage imageNamed:@"delete3.png"] forSearchBarIcon:UISearchBarIconClear 
                   state:UIControlStateHighlighted];

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.image = [UIImage imageNamed:@"search.png"];
    [self.view addSubview:view];
    
    [self.view addSubview:searchBar_];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    tableView_.dataSource = self;
    tableView_.delegate = self;
    tableView_.rowHeight = [ShowCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *backImage = [UIImage imageNamed:@"backButton@2x.png"];  
    [back setImage:backImage forState:UIControlStateNormal];  
    
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];  
    back.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);  
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    [self.view addSubview:tableView_];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG("indexPath = %@", indexPath);
    
    static NSString *MyIdentifier = @"someIdentifier";    
    ShowCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[ShowCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:MyIdentifier];
    }    
    [cell setShow:[filteredShows_ objectAtIndex:indexPath.row]];
   
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
    DLOG("didselect...");
    
    ShowVC *vc = [[ShowVC alloc] init];
    [vc setShow:[filteredShows_ objectAtIndex:indexPath.row]];
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
