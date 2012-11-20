#import "EpisodeVC.h"
#import "utils.h"
#import "UIImageView+WebCache.h"
#import "UIBarButtonItem+CustomImage.h"

@implementation EpisodeVC

@synthesize episode = episode_;

- (void)viewDidLoad
{
    UIColor *myDarkPurple_ = [UIColor colorWithRed:0x65/255.0 green:0x56/255.0 blue:0x74/255.0 alpha:1.0];
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    background.image = [UIImage imageNamed:@"details"];
    
    [self.view addSubview:background];
 
    NSString *urlImage = @"http://thetvdb.com/banners/_cache/";
    NSString *fullUrl = [urlImage stringByAppendingString:episode_.image];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    [pic setClipsToBounds:YES];
    
    if (![fullUrl isEqualToString:urlImage]) {
        [pic setImageWithURL:[NSURL URLWithString:fullUrl] placeholderImage:[UIImage imageNamed:@"placeholder_show_bright"]];
    } else {
        DLOG("empty picture adress");
        [pic setImage:[UIImage imageNamed:@"placeholder_show_bright"]];
    }

    [self.view addSubview:pic];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [episode_.name copy];
    title.lineBreakMode = UILineBreakModeWordWrap;
    title.textColor = myDarkPurple_;
    [title setNumberOfLines:0];
    
    [title sizeToFit];
    
    [self.view addSubview:title];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(275, 2, 123, 15)]; //95
    number.text = episode_.readableNumber;
    [number setFont:[UIFont fontWithName:@"Arial" size:13]];
    number.lineBreakMode = UILineBreakModeWordWrap;
    number.backgroundColor = [UIColor clearColor];
    [number sizeToFit];
    number.textColor = [UIColor grayColor];
    [self.view addSubview:number];
    
    UIScrollView *textView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 136, 300, 213)];
    
    CGRect textRect = textView.frame;
    textRect.origin.x = 0;
    textRect.origin.y = 0;
    
    UILabel *description = [[UILabel alloc] initWithFrame:textRect];
    description.text = [episode_.description copy];
    
    if (!description.text.length) {
        description.text = @"No description available.";
    }
    
    [description setFont:[UIFont fontWithName:@"Arial" size:17]];
    description.lineBreakMode = UILineBreakModeWordWrap;
    [description setNumberOfLines:0];
    description.textColor = myDarkPurple_;
    [description sizeToFit];
    
    description.backgroundColor = [UIColor clearColor];
    
    CGSize textSize = description.frame.size;
    
    textView.contentSize = textSize;    
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];        

    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@""
                                    backgroundImage:[UIImage imageNamed:@"back_long"]
                                    backgroundHighlightedImage:[UIImage imageNamed:@"back_long"]
                                    target:self
                                    action:@selector(goback)];
    
    self.navigationItem.leftBarButtonItem = backBarItem;
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end