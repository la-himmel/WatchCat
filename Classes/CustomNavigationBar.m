#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"navbar@2x.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
//    [self setBackgroundImage:[UIImage imageNamed: @"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    
}

@end
