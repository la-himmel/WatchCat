//  AdvancedNavigationBar.h

#import "AdvancedBarCommon.h"

@interface AdvancedNavigationBar: UINavigationBar

@property (nonatomic, assign) AdvancedBarStyle advancedStyle;
@property (nonatomic, retain) UIImage *backgroundImage;

@end

@interface UINavigationBar (UINavigationBar_Advanced)

@property (nonatomic, assign) AdvancedBarStyle advancedStyle;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, assign) BOOL shadowHidden;

@end
