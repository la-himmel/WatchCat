#import "ShowVC.h"
#import "utils.h"
#import "TVShow.h"
#import "CustomBarButtonItem.h"
#import "XMLDeserialization.h"
#import "UIImageView+WebCache.h"
#import "ScheduleVC.h"
#import "EpisodeListVC.h"
#import "UIBarButtonItem+CustomImage.h"

@interface ShowVC() 
{
    TVShow *show_;
    
    UIButton *subscribeButton_;
    UIButton *bookmarkButton_;
    UIButton *episodeButton_;
    
    int currentTab_;
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation ShowVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;
@synthesize spinner = spinner_;

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:[NSString
            stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%@/all/en.xml",
            show_.idString]];
    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];    
    NSString *urlImage = @"http://thetvdb.com/banners/_cache/";
    show_.image = [urlImage stringByAppendingString:parseImageUrl(xmlData)];
    show_.status = parseStatus(xmlData);
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    background.image = [UIImage imageNamed:@"details"];
    
    [self.view addSubview:background];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    [pic setClipsToBounds:YES];

    if (![show_.image isEqualToString:urlImage]) {
        [pic setImageWithURL:[NSURL URLWithString:show_.image] placeholderImage:[UIImage imageNamed:@"placeholder_show_bright"]];
    } else {
        DLOG("empty picture adress");
        [pic setImage:[UIImage imageNamed:@"placeholder_show_bright"]];
    }

    [self.view addSubview:pic];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [show_.name copy];
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title setNumberOfLines:0];
    [title sizeToFit];
//    title.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:title];
    
    if (show_.nearestAirDate != nil) {
        UILabel *nearestTitle = [[UILabel alloc] initWithFrame:CGRectMake(188, 80, 123, 25)];
        nearestTitle.text = @"Next episode: ";
        [nearestTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
        nearestTitle.lineBreakMode = UILineBreakModeWordWrap;
        [nearestTitle setNumberOfLines:0];
        [nearestTitle sizeToFit];
        [self.view addSubview:nearestTitle];
                
        UILabel *nearestDate = [[UILabel alloc] initWithFrame:CGRectMake(188, 100, 123, 25)];
        nearestDate.text = show_.nearestAirDate;
        [nearestDate setFont:[UIFont fontWithName:@"Arial" size:14]];
        nearestDate.lineBreakMode = UILineBreakModeWordWrap;
        [nearestDate setNumberOfLines:0];
        [nearestDate sizeToFit];
        [self.view addSubview:nearestDate];
    } 
    
    UIScrollView *textView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 136, 300, 213)];
    
    CGRect textRect = textView.frame;
    textRect.origin.x = 0;
    textRect.origin.y = 0;
    
    UILabel *description = [[UILabel alloc] initWithFrame:textRect];
    description.text = [show_.description copy];
    
    if (!description.text.length) {
        description.text = @"No description available.";
    }
    
    [description setFont:[UIFont fontWithName:@"Arial" size:17]];
    description.lineBreakMode = UILineBreakModeWordWrap;
    [description setNumberOfLines:0];
    [description sizeToFit];

    description.backgroundColor = [UIColor clearColor];
    
    CGSize textSize = description.frame.size;
    textSize.height += 190;
    
    textView.contentSize = textSize;    
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];
    
    subscribeButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                                    10 + description.frame.size.height, 300, 50)];
    [subscribeButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [subscribeButton_ setBackgroundImage:[UIImage imageNamed:@"button_active3"] forState:UIControlStateHighlighted];
    [subscribeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
    bookmarkButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                70 + description.frame.size.height, 300, 50)];
    [bookmarkButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bookmarkButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [bookmarkButton_ setBackgroundImage:[UIImage imageNamed:@"button_active2"] forState:UIControlStateHighlighted];
    
    episodeButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                                                 130 + description.frame.size.height, 300, 50)];
    [episodeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [episodeButton_ setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [episodeButton_ setBackgroundImage:[UIImage imageNamed:@"button_active2"] forState:UIControlStateHighlighted];
    [episodeButton_ addTarget:self action:@selector(showEpisodeList) forControlEvents:UIControlEventTouchUpInside];
    [episodeButton_ setTitle:@"Episode list" forState:UIControlStateNormal];
    [textView addSubview:episodeButton_];
    
    NSString *upText = @"Subscribe";
    NSString *downText = @"Remember";
    
    if (currentTab_ == 1) {
        [subscribeButton_ addTarget:self action:@selector(addToFavourites) forControlEvents:UIControlEventTouchUpInside];
        [bookmarkButton_ addTarget:self action:@selector(rememberShow) forControlEvents:UIControlEventTouchUpInside];        
    } else if (currentTab_ == 0) {
        upText = @"Unsubscribe";
        [subscribeButton_ addTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
    } else if (currentTab_ == 3) {
        downText = @"Forget";
        [bookmarkButton_ addTarget:self action:@selector(forgetShow) forControlEvents:UIControlEventTouchUpInside];        
    }

    [subscribeButton_ setTitle:upText forState:UIControlStateNormal];    
    [bookmarkButton_ setTitle:downText forState:UIControlStateNormal];

    [textView addSubview:subscribeButton_];
    [textView addSubview:bookmarkButton_];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    backgroundImage:[UIImage imageNamed:@"back_long"]
                                    backgroundHighlightedImage:[UIImage imageNamed:@"back_long"]
                                    target:self
                                    action:@selector(goback)];
    
    self.navigationItem.leftBarButtonItem = backBarItem;
}

- (void)setSwitcher:(id<TabSwitcher>)sw
{
    switcher_ = sw;
    currentTab_ = [switcher_ currentTab];
}

- (id<TabSwitcher>)switcher
{
    return switcher_;
}

- (void)setShow:(TVShow *)show
{
    show_ = show;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)addressIsAvailable
{
    NSError *error;
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.thetvdb.com"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    return ( URLString != NULL ) ? YES : NO;
}

- (void)showEpisodeList
{
    DLOG("Need to show episode list... %d", [[show_ episodes] count]);
    
    //if there is no internet connection, show popup
    if (![self addressIsAvailable]) {
        [self alertWithMessage:@"There is no internet connection or host is unavailable"];
        return;
    }

    
    spinner_ = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner_ startAnimating];
    
    CGRect sp = CGRectMake((self.view.frame.size.width - spinner_.frame.size.width) /2,
                           (self.view.frame.size.height - spinner_.frame.size.height) /2,
                           spinner_.frame.size.width,
                           spinner_.frame.size.height);
    [spinner_ setFrame:sp];
    [self.view addSubview:spinner_];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("loader", NULL);
    dispatch_async(downloadQueue, ^{
        EpisodeListVC *vc;
        if ([[show_ episodes] count] == 0) {
            vc = [[EpisodeListVC alloc] initWithShow:show_];
//        } else {
//            vc = [[EpisodeListVC alloc] initWithItems:[show_ episodes]];
        }
        
        vc.myseries = myseries_;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
            [spinner_ stopAnimating];
        });
    });
        
    
}

- (void)forgetShow
{
    [myseries_ forgetShow:show_];
//    [self.navigationController popViewControllerAnimated:YES];    
    [bookmarkButton_ setTitle:@"Remember" forState:UIControlStateNormal];
    [bookmarkButton_ addTarget:self action:@selector(rememberShow) 
               forControlEvents:UIControlEventTouchUpInside];
    [bookmarkButton_ setNeedsDisplay];
}

- (void)unsubscribe
{
    [myseries_ removeFromFavorites:show_];
    [subscribeButton_ setTitle:@"Subscribe" forState:UIControlStateNormal];
    [subscribeButton_ addTarget:self action:@selector(addToFavourites) 
         forControlEvents:UIControlEventTouchUpInside];
    [subscribeButton_ setNeedsDisplay];
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

- (void)alertForCancelAndOkWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:delegate
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self rememberShow];
    }
}

- (void)rememberShow
{
    if (![myseries_ rememberShow:show_]) {
        [self alertWithMessage:@"This show is already in your bookmarks."];
        return;
    } 
    
    if ([switcher_ currentTab] != 3) {
        [switcher_ goToRootAndRefreshTab:3];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addToFavourites
{
    if ([show_.status isEqual:@"Ended"]) {
        NSString *msg = @"This show is ended. Do you want to add it to you bookmarks?";
        [self alertForCancelAndOkWithMessage:msg delegate:self];
        return;
    }
    
    if (![myseries_ addToFavorites:show_]) {
        [self alertWithMessage:@"This show is already in your favourutes."];
        return;
    }
    
    if ([switcher_ currentTab] != 0) {
        [switcher_ goToRootAndRefreshTab:0];        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end