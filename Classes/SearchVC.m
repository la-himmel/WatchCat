#import "SearchVC.h"
#import "ShowVC.h"
#import "SearchCell.h"
#import "ShowCell.h"
#import "utils.h"
#import "UIView+position.h"
#import "TVShow.h"
#import "XMLDeserialization.h"
#import "CustomBarButtonItem.h"
#import "JSONKit.h"

#define MIRROR_PATH @"http://thetvdb.com"
#define API_KEY @"2737B5943CFB6DE1"

@interface SearchVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UISearchBar *searchBar_;
    UITableView *tableView_;
    UIImageView *back_;
    
    UILabel *msg_;
    
    // current search results
    NSArray *filteredShows_;
}
@end

@implementation SearchVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;

- (id)init
{
    DLOG("init");
    
    if (!(self = [super init])) {
        return nil;
    }
    
    [[self navigationController] setNavigationBarHidden:YES];
          
    filteredShows_ = [[NSArray alloc] init];
        
    

    return self;
}

- (void)viewDidLoad
{
    DLOG("view did load");
    
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
    view.image = [UIImage imageNamed:@"search@2x.png"];
    [self.view addSubview:view];  
   
    [self.view addSubview:searchBar_];
        
    back_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];   
    back_.image = [UIImage imageNamed:@"main20@2x.png"];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.backgroundColor = [UIColor redColor];//clearColor];
    tableView_.backgroundView = back_;
            
    tableView_.delegate = self;
    tableView_.rowHeight = [ShowCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView_];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *backImage = [UIImage imageNamed:@"backButton@2x.png"];  
    [backButton setImage:backImage forState:UIControlStateNormal];  
    
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];  
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height); 
    
    msg_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                     (self.view.height - 44 - 25) /2, 
                                                     320, 
                                                     25)];
    msg_.backgroundColor = [UIColor clearColor];
    msg_.textAlignment = UITextAlignmentCenter;
    
    if ([filteredShows_ count] == 0) {
        msg_.text = @"No search results";
        [self.view addSubview:msg_];
    } else {
        [msg_ removeFromSuperview];
    }
    DLOG("view did load end");

//    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backImage];
//    [self.navigationItem setLeftBarButtonItem:barBackButton];    

}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self adjust];
    
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section
{
    return [filteredShows_ count];
}

- (void)setSwitcher:(id<TabSwitcher>)sw
{
    switcher_ = sw;
}

- (id<TabSwitcher>)switcher
{
    return switcher_;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSURL *url = [NSURL URLWithString:[NSString
                     stringWithFormat:@"http://www.thetvdb.com/api/GetSeries.php?seriesname=%@", 
                                        searchBar.text]];
    //TVRage API: 
    //http://services.tvrage.com/feeds/search.php?show=


    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    if (xmlData == nil) {
        DLOG("It's time to show popup!");
    }

    filteredShows_ = parseSearchResults(xmlData);

    [tableView_ reloadData];
    [self adjust];
    [searchBar resignFirstResponder];
}

- (void)adjust
{
    DLOG("adjust, count: %d", [filteredShows_ count]);
    tableView_.bounces = ([filteredShows_ count] > 6);        
    
    NSString *imageName = @"surprise@2x.png";
    if ([filteredShows_ count] == 0) {
        DLOG("no shows");
        imageName = @"main20@2x.png";
    } 
    
    back_.image = [UIImage imageNamed:imageName];
    tableView_.backgroundView = back_;
   
    if ([filteredShows_ count] == 0) {
        msg_.text = @"No search results";
        [self.view addSubview:msg_];
    } else {
        [msg_ removeFromSuperview];
    }

    [msg_ setNeedsDisplay];
    [tableView_.backgroundView setNeedsDisplay];
    [tableView_ setNeedsDisplay];  

}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar_ resignFirstResponder];
    
    ShowVC *vc = [[ShowVC alloc] init];
    [vc setShow:[filteredShows_ objectAtIndex:indexPath.row]];
    [vc setMyseries:myseries_];

    vc.switcher = switcher_;
    
    [[self navigationController] setNavigationBarHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
