#import "ShowCell.h"

#import "TVShow.h"

const CGFloat kHeight = 60;

@implementation ShowCell

- (void)setShow:(TVShow *)show
{
    self.textLabel.text = show.name;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor = [UIColor purpleColor];
}

+ (CGFloat)height
{
    return kHeight;
}

@end
