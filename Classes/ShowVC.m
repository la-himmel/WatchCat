#import "ShowVC.h"
#import "utils.h"
#import "TVShow.h"
#import "CustomBarButtonItem.h"
#import "XMLDeserialization.h"
#import "UIImageView+WebCache.h"
#import "ScheduleVC.h"
#import "EpisodeListVC.h"

@interface ShowVC() 
{
    TVShow *show_;
    
    UIButton *subscribeButton_;
    UIButton *bookmarkButton_;
    UIButton *episodeButton_;
    
    int currentTab_;
}
@end

@implementation ShowVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;

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
    background.image = [UIImage imageNamed:@"details@2x.png"];
    
    [self.view addSubview:background];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    [pic setClipsToBounds:YES];
    [pic setImageWithURL:[NSURL URLWithString:show_.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:pic];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [show_.name copy];
    [title setFont:[UIFont fontWithName:@"Arial" size:19]];
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title setNumberOfLines:0];
    [title sizeToFit];

    [self.view addSubview:title];

    if (show_.nearestEpisode != nil) {
//        DLOG("NEAREST: %@ %@", [show_.nearestEpisode readableNumber], [show_.nearestEpisode name]);
                
        UILabel *nearestTitle = [[UILabel alloc] initWithFrame:CGRectMake(188, 90, 123, 25)];
        nearestTitle.text = [[NSString alloc] initWithString:@"Next episode: "];
        [nearestTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
        nearestTitle.lineBreakMode = UILineBreakModeWordWrap;
        [nearestTitle setNumberOfLines:0];
        [nearestTitle sizeToFit];
        [self.view addSubview:nearestTitle];
        
        
        UILabel *nearestDate = [[UILabel alloc] initWithFrame:CGRectMake(188, 110, 123, 25)];
        nearestDate.text = show_.nearestEpisode.airDate;
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
    [subscribeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];    
       
    bookmarkButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                70 + description.frame.size.height, 300, 50)];
    [bookmarkButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bookmarkButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    
    episodeButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                                                 130 + description.frame.size.height, 300, 50)];
    [episodeButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [episodeButton_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
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
    
//    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)];
//    [editButton setImage:[UIImage imageNamed:@"back_OFF.png"] forState:UIControlStateNormal];
//    [editButton setImage:[UIImage imageNamed:@"back_ON.png"] forState:UIControlStateSelected];
    
//    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
//    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"                                                                style:UIBarButtonItemStyleDone target:nil action:nil];

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

- (void)showEpisodeList
{
    DLOG("Need to show episode list... %d", [[show_ episodes] count]);
    EpisodeListVC *vc;
    if ([[show_ episodes] count] == 0) {
        vc = [[EpisodeListVC alloc] initWithShow:show_];
    } else {
        vc = [[EpisodeListVC alloc] initWithItems:[show_ episodes]];
    }
    
    vc.myseries = myseries_;
        
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetShow
{
    [myseries_ forgetShow:show_];
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)unsubscribe
{
    [myseries_ removeFromFavorites:show_];
    [bookmarkButton_ setTitle:@"Subscribe" forState:UIControlStateNormal];
    [bookmarkButton_ addTarget:self action:@selector(addToFavourites) 
         forControlEvents:UIControlEventTouchUpInside];
    [bookmarkButton_ setNeedsDisplay];
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
        NSString *msg = [[NSString alloc] 
            initWithString:@"This show is ended. Do you want to add it to you bookmarks?"];
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