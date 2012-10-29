//  AdvancedNavigationBar.m

#import "AdvancedNavigationBar.h"
#import "LoadableCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation AdvancedNavigationBar
#pragma mark - properties
@synthesize advancedStyle = style_;
@synthesize backgroundImage = backgroundImage_;

- (void)setAdvancedStyle:(AdvancedBarStyle)style
{
  if (style_ == style) return;
  style_ = style;
  if ((style) && (!self.backgroundColor)) self.backgroundColor = [UIColor clearColor];
  [self setNeedsDisplay];
}
- (void)setBackgroundImage:(UIImage *)image
{
  [image retain];
  [backgroundImage_ release];
  backgroundImage_ = image;
  [self setNeedsDisplay];
}

#pragma mark - lifecycle
- (void)dealloc
{
  self.backgroundImage = nil;
  [super dealloc];
}

#pragma mark - drawing
- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  id pool = [[NSAutoreleasePool alloc] init];
  UIColor *fillColor = self.backgroundColor;
  switch (self.advancedStyle) {
    case AdvancedBarStyleTextured:{
      if (self.backgroundImage) {
        if (self.backgroundImage.topCapHeight || self.backgroundImage.leftCapWidth) {
          [self.backgroundImage drawInRect:self.bounds];
        } else {
          [self.backgroundImage drawAsPatternInRect:self.bounds];
        }
        return;
      }
    }
    case AdvancedBarStyleSolidColor:{
      [fillColor setFill];
      CGContextFillRect(ctx, rect);
      return;
    }
    default:
      //AdvancedTabBarStyleNone
      [super drawRect:rect];
      break;
  }
  [pool drain];
}

@end

MAKE_CATEGORY_LOADABLE(UINavigationBar_UINavigationBar_Advanced)
@implementation UINavigationBar (UINavigationBar_Advanced)

- (void)setAdvancedStyle:(AdvancedBarStyle)style
{
  //do nothing
}
- (AdvancedBarStyle)advancedStyle
{
  return AdvancedBarStyleNone;
}
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
  //do nothing
}
- (UIImage *)backgroundImage
{
  return nil;
}
- (void)setShadowHidden:(BOOL)shadowHidden
{
  if (shadowHidden) {
    self.layer.shadowRadius = 0.f;
    self.layer.shadowOpacity = 0.f;
    self.layer.shadowOffset = CGSizeZero;
    return;
  }
  CGFloat radius = 4.f;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.3f;
  self.layer.shadowOffset = (CGSize){0.f, 1.f};
  self.layer.shadowRadius = radius;
}
- (BOOL)shadowHidden
{
  return (self.layer.shadowRadius == 0.f);
}

@end

