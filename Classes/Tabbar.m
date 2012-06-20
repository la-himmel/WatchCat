#import "Tabbar.h"
#import "utils.h"
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

    for (int i = 0; i < (sizeof(ui.buttonFrames)/sizeof(ui.buttonFrames[0])); ++i) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = ui.buttonFrames[i];
        
        if (i == 0) {
            [b addTarget:self action:@selector(scheduleSelected) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            [b addTarget:self action:@selector(searchSelected) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            [b addTarget:self action:@selector(settingsSelected) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [b addTarget:self action:@selector(savedSelected) forControlEvents:UIControlEventTouchUpInside];
        } 
                
        [b setImage:uu(ui.buttonImages[i]) forState:UIControlStateNormal];

        [self addSubview:b];
        [buttons_ addObject:b];
    }

    return self;
}

- (void)scheduleSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 0;
    [self didChangeValueForKey:@"selectedIndex"];
}

- (void)searchSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 1;
    [self didChangeValueForKey:@"selectedIndex"];
}

- (void)settingsSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 2;
    [self didChangeValueForKey:@"selectedIndex"];
}

- (void)savedSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 3;
    [self didChangeValueForKey:@"selectedIndex"];
}
@end
