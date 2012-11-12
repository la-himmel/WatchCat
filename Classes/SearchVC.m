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
    BOOL keyboardOpen_;
    UIGestureRecognizer *recognizer_;
    
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation SearchVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;
@synthesize spinner = spinner_;

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    keyboardOpen_ = NO;
    recognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(closeKeyboard)];
    
//    [[self navigationController] setNavigationBarHidden:YES];
          
    filteredShows_ = [[NSArray alloc] init];

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
    view.image = [UIImage imageNamed:@"search"];
    [self.view addSubview:view];  
   
    [self.view addSubview:searchBar_];
        
    back_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];   
    back_.image = [UIImage imageNamed:@"mainClouds"];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.height - 44)];
    tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView_.dataSource = self;
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.backgroundView = back_;
            
    tableView_.delegate = self;
    tableView_.rowHeight = [ShowCell height];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView_];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *backImage = [UIImage imageNamed:@"backButton"];  
    [backButton setImage:backImage forState:UIControlStateNormal];  
    
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];  
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height); 
    
    msg_ = [[UILabel alloc] initWithFrame:CGRectMake(28, 
                                                     149, 
                                                     320, 
                                                     25)];
    msg_.backgroundColor = [UIColor clearColor];
    msg_.textColor = [UIColor colorWithRed:0x92/255.0 green:0x88/255.0 blue:0x96/255.0 alpha:0.9];
    msg_.textAlignment = UITextAlignmentLeft;
    
    if ([filteredShows_ count] == 0) {
        msg_.text = @"No results";
        [self.view addSubview:msg_];
    } else {
        [msg_ removeFromSuperview];
    }
            
    DLOG("view did load end");
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    DLOG("start");
    [self.view addGestureRecognizer:recognizer_];

    return YES;
}

- (void)closeKeyboard
{
    DLOG("close keyboard?");
    [searchBar_ resignFirstResponder];
    [self.view removeGestureRecognizer:recognizer_];
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
   
    NSArray *backs = [[NSArray alloc] initWithObjects:@"main1", @"main2",
                      @"main3", @"main4", @"main5", @"main6", nil];

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

- (BOOL)addressIsAvailable
{
    NSError *error;
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.thetvdb.com"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    return ( URLString != NULL ) ? YES : NO;
}

- (void)alertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (![self addressIsAvailable]) {
        [self alertWithMessage:@"There is no internet connection or host is unavailable"];
        return;
    }

    spinner_ = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner_ startAnimating];
    
    CGRect sp = CGRectMake((tableView_.frame.size.width - spinner_.frame.size.width) /2,
                           (tableView_.frame.size.height - spinner_.frame.size.height) /2,
                           spinner_.frame.size.width,
                           spinner_.frame.size.height);
    
    DLOG("spinner rect: %@", NSStringFromCGRect(sp));
    
    [spinner_ setFrame:sp];
//    [tableView_ addSubview:spinner_];
    [self.view addSubview:spinner_];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{
        NSString *replaced = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:[NSString
                                           stringWithFormat:@"http://www.thetvdb.com/api/GetSeries.php?seriesname=%@",
                                           replaced]];
        //TVRage API:
        //http://services.tvrage.com/feeds/search.php?show=        
        
        NSData *xmlData = [NSData dataWithContentsOfURL:url];
        if (xmlData == nil) {
            DLOG("It's time to show popup!");
        }
        
        filteredShows_ = parseSearchResults(xmlData);

        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView_ reloadData];
            [self adjust];
            [spinner_ stopAnimating];
        });
    });
}

- (void)adjust
{
    tableView_.bounces = ([filteredShows_ count] >= 6);
    
    NSString *imageName = @"surpriseBr";
    if ([filteredShows_ count] == 0) {
        DLOG("count == 0");
        imageName = @"mainClouds";
    } else if ([filteredShows_ count] < 6) {
        imageName = @"main20";
    } 
    
    back_.image = [UIImage imageNamed:imageName];
    tableView_.backgroundView = back_;
   
    if ([filteredShows_ count] == 0) {
        msg_.text = @"No results";
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
    
    spinner_ = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner_ startAnimating];
    
    CGRect sp = CGRectMake((tableView_.frame.size.width - spinner_.frame.size.width) /2,
                           (tableView_.frame.size.height - spinner_.frame.size.height) /2,
                           spinner_.frame.size.width,
                           spinner_.frame.size.height);
    [spinner_ setFrame:sp];
//    [tableView_ addSubview:spinner_];
     [self.view addSubview:spinner_];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{
        ShowVC *vc = [[ShowVC alloc] init];
        [vc setShow:[filteredShows_ objectAtIndex:indexPath.row]];
        [vc setMyseries:myseries_];
        
        vc.switcher = switcher_;
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[self navigationController] setNavigationBarHidden:NO];
            [self.navigationController pushViewController:vc animated:YES];
            [spinner_ stopAnimating];
        });
    });
}

@end
