#import "ShowCell.h"

#import "TVShow.h"

const CGFloat kHeight = 60;

@implementation ShowCell

- (void)setShow:(TVShow *)show
{
    self.textLabel.text = show.name;
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    UIColor *myDarkPurple = [UIColor colorWithRed:0x65/255.0 green:0x56/255.0 blue:0x74/255.0 alpha:1.0];
    self.textLabel.textColor = myDarkPurple;
    
    UIColor *myPurple = [UIColor colorWithRed:0x60/255.0 green:0x40/255.0 blue:0x79/255.0 alpha:1.0];
    self.textLabel.highlightedTextColor = myPurple;
}

+ (CGFloat)height
{
    return kHeight;
}

@end
