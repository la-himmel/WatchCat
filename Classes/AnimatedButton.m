#import "AnimatedButton.h"

#import <QuartzCore/QuartzCore.h>

#import "utils.h"

@interface AnimatedButton ()
{
    UIImageView *overlay_;
    UIImageView *background_;
}
@end

@implementation AnimatedButton

@synthesize image = image_;
@synthesize selectedImage = selectedImage_;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }

    background_ = [[UIImageView alloc] initWithFrame:self.bounds];
    background_.autoresizingMask = UIViewAutoresizingFlexibleHeight
        | UIViewAutoresizingFlexibleWidth;
    [self addSubview:background_];

    overlay_ = [[UIImageView alloc] initWithFrame:self.bounds];
    overlay_.autoresizingMask = UIViewAutoresizingFlexibleHeight
        | UIViewAutoresizingFlexibleWidth;
    overlay_.alpha = 0.0;
    [self addSubview:overlay_];

    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (selected) {
        overlay_.alpha = 1;
        background_.image = image_;

        [UIView animateWithDuration:0.3 animations:^{
            overlay_.alpha = 0.0;
        }
        completion:^(BOOL finished){
            if (self.selected) {
                background_.image = selectedImage_;
            }
        }];
    } else {
        overlay_.alpha = 0.0;
        background_.image = image_;
    }
}

- (void)setOverlayImage:(UIImage *)image
{
    overlay_.image = image;
}

- (UIImage *)overlayImage
{
    return overlay_.image;
}

@end
