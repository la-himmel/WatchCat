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
    
    UIImageView *photo_;
    UIView *calcView_;
    
    BOOL noResize;
    BOOL loading;
    
    int currentTab_;
    UIColor *myDarkPurple_; 
}
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ShowVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;
@synthesize spinner = spinner_;
@synthesize scrollView = scrollView_;
@synthesize isAFavouriteShow = isAFavouriteShow_;
@synthesize isABookmarkedShow = isABookmarkedShow_;

- (void)viewDidLoad
{
    myDarkPurple_ = [UIColor colorWithRed:0x65/255.0 green:0x56/255.0 blue:0x74/255.0 alpha:1.0];
    loading = NO;
    
    //setting page background
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    background.image = [UIImage imageNamed:@"details"];
    [self.view addSubview:background];
 
    //getting image url
    NSURL *url = [NSURL URLWithString:[NSString
            stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%@/all/en.xml",
            show_.idString]];
    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    NSString *urlImage = @"http://thetvdb.com/banners/_cache/";
    show_.image = [urlImage stringByAppendingString:parseImageUrl(xmlData)];
    DLOG("picture address: %@", show_.image);
    
    show_.status = parseStatus(xmlData);

    //photo resizable
    photo_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 146, 87)]; //146 87 / 300 167
    photo_.contentMode = UIViewContentModeScaleAspectFill;
    [photo_ setClipsToBounds:YES];
    [photo_ setMultipleTouchEnabled:NO];
    [photo_ setExclusiveTouch:YES];
    
    //dont resize if its placeholder
    if (![show_.image isEqualToString:urlImage]) {
        [photo_ setImageWithURL:[NSURL URLWithString:show_.image]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
        noResize = NO;
    } else {
        DLOG("empty picture adress");
        [photo_ setImage:[UIImage imageNamed:@"placeholder_show_bright"]];
        noResize = YES;
    }
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    scrollView_.delegate = self;
    
//    scrollView_.contentSize = CGSizeMake(300, 167);
    scrollView_.contentSize = CGSizeMake(photo_.frame.size.width, photo_.frame.size.height);
    scrollView_.contentOffset = CGPointMake(0.0, 0.0);
    scrollView_.minimumZoomScale = 1.0;
    scrollView_.maximumZoomScale = 2.054;
    scrollView_.zoomScale = 1.0;
    [scrollView_ setMultipleTouchEnabled:NO];
    [scrollView_ setExclusiveTouch:YES];
    [scrollView_ setScrollEnabled:NO];
    [scrollView_ addSubview:photo_];
    
    for (UIGestureRecognizer* recognizer in [scrollView_ gestureRecognizers]) {
        if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
            [recognizer setEnabled:NO];
        }
    }
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                                 action:@selector(handleDoubleTap:)];

    [doubleTap setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTap];
   
    
    [self fillWithContent];
    [self fillScrollPanel];
            
    //adding calc
    calcView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    calcView_.backgroundColor = [UIColor colorWithRed:0x92/255.0 green:0x88/255.0 blue:0x96/255.0 alpha:0.5];
    [self.view addSubview:calcView_];
    [calcView_ setHidden:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(closePic)];
    [singleTap setNumberOfTapsRequired:1];
    [calcView_ addGestureRecognizer:singleTap];
    
    //adding scrollview so that is  on top
    [self.view addSubview:scrollView_];
    

    [self addBackButton];
}

- (void)closePic
{
    if (noResize) {
        return;
    }
    
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    [UIView animateWithDuration:.250
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [calcView_ setHidden:YES];
                     }
                     completion:nil];
    
    
    [self.scrollView setFrame:CGRectMake(20, 20, 146, 87)];    
}

- (void)fillWithContent
{
    //filling the page w content
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [show_.name copy];
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title setNumberOfLines:0];
    [title sizeToFit];
    title.textColor = myDarkPurple_;
    [self.view addSubview:title];
    
    //nearest episode for series
    if (show_.nearestAirDate != nil) {
        UILabel *nearestTitle = [[UILabel alloc] initWithFrame:CGRectMake(188, 80, 123, 25)];
        nearestTitle.text = @"Next episode: ";
        [nearestTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
        nearestTitle.lineBreakMode = UILineBreakModeWordWrap;
        [nearestTitle setNumberOfLines:0];
        [nearestTitle sizeToFit];
        nearestTitle.textColor = myDarkPurple_;
        [self.view addSubview:nearestTitle];
        
        UILabel *nearestDate = [[UILabel alloc] initWithFrame:CGRectMake(188, 100, 123, 25)];
        nearestDate.text = show_.nearestAirDate;
        [nearestDate setFont:[UIFont fontWithName:@"Arial" size:14]];
        nearestDate.lineBreakMode = UILineBreakModeWordWrap;
        [nearestDate setNumberOfLines:0];
        [nearestDate sizeToFit];
        nearestDate.textColor = myDarkPurple_;
        [self.view addSubview:nearestDate];
    }

}

- (void)fillScrollPanel
{
    //description
    UIScrollView *textView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 136, 300, 227)];
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


    description.textColor = myDarkPurple_;
    
    CGSize textSize = description.frame.size;
    textSize.height += 190;
    
    textView.contentSize = textSize;
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];
    
    [self initializeButtonsAfterRect:description.frame];
    
    if (![episodeButton_ isEqual:nil]) {
        [textView addSubview:episodeButton_];
    }
    
    if (![subscribeButton_ isEqual:nil]) {
        [textView addSubview:subscribeButton_];
    }
    
    if (![bookmarkButton_ isEqual:nil]) {
        [textView addSubview:bookmarkButton_];
    }
}

- (void)addBackButton
{
    //back button
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    backgroundImage:[UIImage imageNamed:@"back_long"]
                                    backgroundHighlightedImage:[UIImage imageNamed:@"back_long"]
                                    target:self
                                    action:@selector(goback)];
    
    self.navigationItem.leftBarButtonItem = backBarItem;
    
}

- (void)initializeButtonsAfterRect:(CGRect)rect
{
    //buttons
    CGRect rect1 = CGRectMake(0, 10 + rect.size.height, 300, 50);
    CGRect rect2 = CGRectMake(0, 70 + rect.size.height, 300, 50);
    CGRect rect3 = CGRectMake(0, 130 + rect.size.height, 300, 50);
    CGRect zeroRect = CGRectMake(0, 0, 0, 0);
    
    CGRect favRect = rect1, bookmRect = rect2, epRect = rect3;
    
    if (self.isABookmarkedShow) {
        favRect = zeroRect;
        bookmRect = rect1;
        epRect = rect2;
    } else if (self.isAFavouriteShow) {
        bookmRect = zeroRect;
        epRect = rect2;
    }
    
    
    if (!self.isABookmarkedShow) {
        subscribeButton_ = [[UIButton alloc] initWithFrame:favRect];
        [subscribeButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [subscribeButton_ setBackgroundImage:[UIImage imageNamed:@"button_active3.png"] forState:UIControlStateHighlighted];
        [subscribeButton_ setTitleColor:myDarkPurple_ forState:UIControlStateNormal];
        
        if (!self.isAFavouriteShow) {
            [subscribeButton_ addTarget:self action:@selector(addToFavourites) forControlEvents:UIControlEventTouchUpInside];
            [subscribeButton_ setTitle:@"Subscribe" forState:UIControlStateNormal];
        } else {
            [subscribeButton_ addTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
            [subscribeButton_ setTitle:@"Unsubscribe" forState:UIControlStateNormal];
        }
    
    }
    if (!self.isAFavouriteShow) {
        bookmarkButton_ = [[UIButton alloc] initWithFrame:bookmRect];
        [bookmarkButton_ setTitleColor:myDarkPurple_ forState:UIControlStateNormal];
        [bookmarkButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [bookmarkButton_ setBackgroundImage:[UIImage imageNamed:@"button_active2.png"] forState:UIControlStateHighlighted];
        
        if (!self.isABookmarkedShow) {
            [bookmarkButton_ addTarget:self action:@selector(rememberShow) forControlEvents:UIControlEventTouchUpInside];
            [bookmarkButton_ setTitle:@"Remember" forState:UIControlStateNormal];
            
        } else {
            [bookmarkButton_ addTarget:self action:@selector(forgetShow) forControlEvents:UIControlEventTouchUpInside];
            [bookmarkButton_ setTitle:@"Forget" forState:UIControlStateNormal];
        }
    }
    
    episodeButton_ = [[UIButton alloc] initWithFrame:epRect];
    [episodeButton_ setTitleColor:myDarkPurple_ forState:UIControlStateNormal];
    [episodeButton_ setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [episodeButton_ setBackgroundImage:[UIImage imageNamed:@"button_active1"] forState:UIControlStateHighlighted];
    [episodeButton_ addTarget:self action:@selector(showEpisodeList) forControlEvents:UIControlEventTouchUpInside];
    [episodeButton_ setTitle:@"Episode list" forState:UIControlStateNormal];
 
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (noResize) {
        return;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        DLOG("pinch! -----------");
    }
    
    
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self closePic];       
        
    } else {
        [calcView_ setHidden:NO];
        [UIView animateWithDuration:.25
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self.scrollView setFrame:CGRectMake(10, 60, 300, 167)];
                         }
                         completion:nil];
        [scrollView_ setZoomScale:scrollView_.maximumZoomScale animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return photo_;
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
    if (!loading) {
        loading = YES;
    } else {
        return;
    }
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