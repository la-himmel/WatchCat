#import "ShowVC.h"
#import "utils.h"
#import "TVShow.h"
#import "CustomBarButtonItem.h"
#import "XMLDeserialization.h"
#import "UIImageView+WebCache.h"
#import "ScheduleVC.h"
#import "BookmarkedVC.h"

@interface ShowVC() 
{
    TVShow *show_;
    
    UIButton *upButton;
    UIButton *downButton;
}
@end

@implementation ShowVC
@synthesize myseries = myseries_;
@synthesize switcher = switcher_;

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:[NSString
            stringWithFormat:@"http://www.thetvdb.com/api/2737B5943CFB6DE1/series/%d/all/en.xml",
            show_.num]];
    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];    
    NSString *urlImage = @"http://thetvdb.com/banners/_cache/";
    show_.image = [urlImage stringByAppendingString:parseImageUrl(xmlData)];
    
//    show_.status = parseStatus(xmlData);
//    DLOG("Status: %@", show_.status);
    
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
        DLOG("NEAREST: %@ %@", [show_.nearestEpisode readableNumber], [show_.nearestEpisode name]);
                
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
    } else {
        DLOG("no nearest episode");
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

//    CGFloat red = 61.0;
//    CGFloat blue = 69.0;
//    CGFloat green = 44.0;
//    description.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    description.backgroundColor = [UIColor clearColor];
    
    CGSize textSize = description.frame.size;
    textSize.height += 130;
    
    textView.contentSize = textSize;    
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];
    
    upButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                                    10 + description.frame.size.height, 300, 50)];
    [upButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [upButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
       
    downButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                70 + description.frame.size.height, 300, 50)];
    [downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    
    NSString *upText = @"Subscribe";
    NSString *downText = @"Remember";
    
    if (switcher_ == nil) {
        DLOG("This b is NIL again!111");
    }
    
    if ([switcher_ currentTab] == 1) {
        DLOG("TAB 1");
        [upButton addTarget:self action:@selector(addToFavourites) forControlEvents:UIControlEventTouchUpInside];
        [downButton addTarget:self action:@selector(rememberShow) forControlEvents:UIControlEventTouchUpInside];        
    } else if ([switcher_ currentTab] == 0) {
        DLOG("TAB 0");
        upText = @"Episode list";
        downText = @"Unsubscribe";
        
        [upButton addTarget:self action:@selector(showEpisodeList) forControlEvents:UIControlEventTouchUpInside];
        [downButton addTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];        
    } else if ([switcher_ currentTab] == 3) {
        DLOG("TAB 3");
        upText = @"Episode list";
        downText = @"Forget";
        
        [upButton addTarget:self action:@selector(showEpisodeList) forControlEvents:UIControlEventTouchUpInside];
        [downButton addTarget:self action:@selector(forgetShow) forControlEvents:UIControlEventTouchUpInside];        
    }

    [upButton setTitle:upText forState:UIControlStateNormal];    
    [downButton setTitle:downText forState:UIControlStateNormal];

    [textView addSubview:upButton];
    [textView addSubview:downButton];
}

- (void)setSwitcher:(id<TabSwitcher>)sw
{
    DLOG("setting switcher");
    switcher_ = sw;
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
    DLOG("Need to show episode list...");
}

- (void)forgetShow
{
    [myseries_ forgetShow:show_];
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)unsubscribe
{
    [myseries_ removeFromFavorites:show_];
    [downButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(addToFavourites) 
         forControlEvents:UIControlEventTouchUpInside];
    [downButton setNeedsDisplay];
}

- (void)rememberShow
{
    [myseries_ rememberShow:show_];
    
    if ([switcher_ currentTab] != 3) {
        [switcher_ goToRootAndRefreshTab:3];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addToFavourites
{
    [myseries_ addToFavorites:show_];
    
    if ([switcher_ currentTab] != 0) {
        [switcher_ goToRootAndRefreshTab:0];        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end