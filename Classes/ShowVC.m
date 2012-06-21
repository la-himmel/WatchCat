#import "ShowVC.h"
#import "utils.h"
#import "TVShow.h"
#import "CustomBarButtonItem.h"
#import "XMLDeserialization.h"
#import "UIImageView+WebCache.h"
#import "ScheduleVC.h"


@interface ShowVC() 
{
    TVShow *show_;
}
@end

@implementation ShowVC
@synthesize myseries = myseries_;

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:[NSString
                                       stringWithFormat:@"http://services.tvrage.com/feeds/full_show_info.php?sid=%d",
                                       show_.num]];
    DLOG("%@", [NSString
                stringWithFormat:@"http://services.tvrage.com/feeds/full_show_info.php?sid=%d",
                show_.num]);
    
    NSData *xmlData = [NSData dataWithContentsOfURL:url];
    
    show_.image = [NSURL URLWithString:parseImageUrl(xmlData)];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    background.image = [UIImage imageNamed:@"details@2x.png"];
    
    [self.view addSubview:background];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    [pic setClipsToBounds:YES];
    [pic setImageWithURL:show_.image placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:pic];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [show_.name copy];
    [title setFont:[UIFont fontWithName:@"Arial" size:19]];
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title setNumberOfLines:0];
    [title sizeToFit];

    [self.view addSubview:title];
    
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
    
    UIButton *subscribe = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                                    10 + description.frame.size.height, 300, 50)];
    [subscribe setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [subscribe setTitle:@"Subscribe" forState:UIControlStateNormal];
    [subscribe setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subscribe addTarget:self action:@selector(addToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:subscribe];
    
    UIButton *remember = [[UIButton alloc] initWithFrame:CGRectMake(0, 
                                70 + description.frame.size.height, 300, 50)];
    [remember setTitle:@"Remember" forState:UIControlStateNormal];
    [remember setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [remember addTarget:self action:@selector(rememberShow) forControlEvents:UIControlEventTouchUpInside];
    [remember setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [textView addSubview:remember];

}

- (void)setShow:(TVShow *)show
{
    show_ = show;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rememberShow
{
    [myseries_ rememberShow:show_];
}

- (void)addToFavourites
{
    [myseries_ addToFavorites:show_];
    
    ScheduleVC *vc = [[ScheduleVC alloc] init];
    vc.myseries = myseries_;
    [self.navigationController pushViewController:vc animated:YES];
}


@end