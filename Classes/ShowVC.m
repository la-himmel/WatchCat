#import "ShowVC.h"
#import "utils.h"
#import "TVShow.h"

@interface ShowVC() 
{
    TVShow *show_;
}
@end

@implementation ShowVC

- (void)viewDidLoad
{
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
    back.image = [UIImage imageNamed:@"details@2x.png"];

    [self.view addSubview:back];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 146, 87)];
    pic.image = [UIImage imageNamed:@"series.png"];
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
    
    textView.contentSize = description.frame.size;
    textView.contentMode = UIViewContentModeTop;
    
    [self.view addSubview:textView];
    [textView addSubview:description];
}

- (void)setShow:(TVShow *)show
{
    show_ = show;
}

@end