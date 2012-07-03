#import "EpisodeVC.h"
#import "utils.h"
#import "UIImageView+WebCache.h"

@implementation EpisodeVC

@synthesize episode = episode_;

- (void)viewDidLoad
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    background.image = [UIImage imageNamed:@"details@2x.png"];
    
    [self.view addSubview:background];
 
    NSString *urlImage = @"http://thetvdb.com/banners/_cache/";
    NSString *fullUrl = [urlImage stringByAppendingString:episode_.image];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.contentMode = UIViewContentModeScaleAspectFill;
    [pic setClipsToBounds:YES];
    [pic setImageWithURL:[NSURL URLWithString:fullUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:pic];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(188, 13, 123, 100)];
    title.text = [episode_.name copy];
    [title setFont:[UIFont fontWithName:@"Arial" size:19]];
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title setNumberOfLines:0];
    [title sizeToFit];
    
    [self.view addSubview:title];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(188, 95, 123, 25)];
    number.text = episode_.readableNumber;
    [number setFont:[UIFont fontWithName:@"Arial" size:19]];
    number.lineBreakMode = UILineBreakModeWordWrap;
//    [number setNumberOfLines:0];
    [number sizeToFit];
    [self.view addSubview:number];
    
    UIScrollView *textView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 136, 300, 213)];
    
    CGRect textRect = textView.frame;
    textRect.origin.x = 0;
    textRect.origin.y = 0;
    
    UILabel *description = [[UILabel alloc] initWithFrame:textRect];
    description.text = [episode_.description copy];
    [description setFont:[UIFont fontWithName:@"Arial" size:17]];
    description.lineBreakMode = UILineBreakModeWordWrap;
    [description setNumberOfLines:0];
    [description sizeToFit];
    
    description.backgroundColor = [UIColor clearColor];
    
    CGSize textSize = description.frame.size;
    
    textView.contentSize = textSize;    
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];        
}

@end