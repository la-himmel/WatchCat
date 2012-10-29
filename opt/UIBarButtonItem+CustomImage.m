//
//  UIBarButtonItem+CustomImage.m
//  ButonCommon
//

#import "UIBarButtonItem+CustomImage.h"

@implementation UIBarButtonItem (CustomImage)

       - (id)initWithTitle:(NSString *)title
           backgroundImage:(UIImage *)image
backgroundHighlightedImage:(UIImage *)highlightedImage
                    target:(id)target
                    action:(SEL)action
{
    if ([image
         respondsToSelector:@selector(resizableImageWithCapInsets:)])
        image = [image
                 resizableImageWithCapInsets:(UIEdgeInsets){0,20,0,20}];
    else
        image = [image
                 stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    if ([highlightedImage
         respondsToSelector:@selector(resizableImageWithCapInsets:)])
        highlightedImage = [highlightedImage
                            resizableImageWithCapInsets:(UIEdgeInsets){0,20,0,20}];
    else
        highlightedImage = [highlightedImage
                            stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIButton *barButton = [[UIButton alloc] initWithFrame:(CGRect){{0,0},image.size}];
    UIFont *font = [UIFont fontWithName:barButton.titleLabel.font.fontName size:14];
    barButton.titleLabel.font = font;
    barButton.titleLabel.minimumFontSize = 10;
    barButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    barButton.titleLabel.numberOfLines = 1;
    barButton.titleEdgeInsets = (UIEdgeInsets){0,0,0,0};
    
    CGSize size = [title sizeWithFont:barButton.titleLabel.font
                             forWidth:70
                        lineBreakMode:barButton.titleLabel.lineBreakMode];
    CGFloat width = barButton.frame.size.width;
    if (size.width + 20 > barButton.frame.size.width) {
        width = size.width + 20;
    }
    barButton.frame = (CGRect){barButton.frame.origin,{width, barButton.frame.size.height}};
    
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton setBackgroundImage:image forState:UIControlStateNormal];
    [barButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside]; 
    
    return [self initWithCustomView:barButton];
}

- (id)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
             target:(id)target
             action:(SEL)action
{
    UIButton *barButton = [[UIButton alloc] initWithFrame:(CGRect){{0,0},image.size}];
    [barButton setImage:image forState:UIControlStateNormal];
    [barButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:barButton];
}

@end
