#import "Tabbar.h"

#import "uiTabbar.h"

@interface Tabbar ()
{
    NSMutableArray *buttons_;
}
@end

@implementation Tabbar

@synthesize selectedIndex = selectedIndex_;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }

    UI_SCOPED_ALIAS(ui, uiTabbar);

    UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
    background.image = uu(ui.background);
    [self addSubview:background];

    for (int i=0; i<(sizeof(ui.buttonFrames)/sizeof(ui.buttonFrames[0])); ++i) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = ui.buttonFrames[i];

        [b setImage:uu(ui.buttonImages[i]) forState:UIControlStateNormal];

        [self addSubview:b];
        [buttons_ addObject:b];
    }

    return self;
}

@end
