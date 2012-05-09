#import "ShowCell.h"

#import "TVShow.h"

const CGFloat kHeight = 50;

@implementation ShowCell

- (void)setShow:(TVShow *)show
{
    self.textLabel.text = show.name;
}

+ (CGFloat)height
{
    return kHeight;
}

@end
