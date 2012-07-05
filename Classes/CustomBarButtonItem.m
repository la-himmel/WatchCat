#import "CustomBarButtonItem.h"

@interface CustomBarButtonItem()
{
    UIButton *button;
}
@end

#define kButtonHeight 30
#define kButtonTitleFontSize 12
#define kButtonTitlePadding 5

@implementation CustomBarButtonItem
- (id)initWithTitle:(NSString *)title
{
    button = [UIButton buttonWithType:UIButtonTypeCustom]; 
    
    self = [super initWithCustomView:button];
    if (self) {
        UIFont *titleFont = [UIFont boldSystemFontOfSize:kButtonTitleFontSize];
        button.titleLabel.font = titleFont;
        
        CGSize titleSize = [title sizeWithFont:titleFont];
        CGFloat buttonWidth = titleSize.width + kButtonTitlePadding * 2;
        button.frame = CGRectMake(0, 0, buttonWidth, kButtonHeight);
        self.width = buttonWidth;
        
        [button setTitle:title forState:UIControlStateNormal];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"backButton"]; 
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    return self;
}

@end
