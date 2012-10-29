//
//  UIBarButtonItem+CustomImage.h
//  ButonCommon
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem (CustomImage)

        - (id)initWithTitle:(NSString *)title
            backgroundImage:(UIImage *)image
 backgroundHighlightedImage:(UIImage *)highlightedImage
                     target:(id)target
                     action:(SEL)action;

- (id)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
             target:(id)target
             action:(SEL)action;

@end
