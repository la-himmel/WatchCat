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
    
    buttons_ = [[NSMutableArray alloc] init];

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
        } else if (i == 3) {
            [b addTarget:self action:@selector(bookmarkedSelected) forControlEvents:UIControlEventTouchUpInside];
        } 
        
        [b setImage:uu(ui.buttonImages[i]) forState:UIControlStateNormal];
        [b setImage:uu(ui.buttonSelectedImages[i]) forState:UIControlStateHighlighted];

        [self addSubview:b];
        [buttons_ addObject:b];
    }

    return self;
}

- (void)switchButton:(int)index on:(BOOL)on
{
//    DLOG("adjust button: %d %@", index, on ? @"true" : @"false");
    UIButton *b = [buttons_ objectAtIndex:index];
    
    UI_SCOPED_ALIAS(ui, uiTabbar);
    if (on) {
        [b setImage:uu(ui.buttonSelectedImages[index]) forState:UIControlStateNormal];
        [b setImage:uu(ui.buttonSelectedImages[index]) forState:UIControlStateHighlighted];

        b.backgroundColor = [UIColor colorWithRed:0x92/255.0 green:0x88/255.0 blue:0x96/255.0 alpha:0.4];
    } else {
        [b setImage:uu(ui.buttonImages[index]) forState:UIControlStateNormal];
        [b setImage:uu(ui.buttonImages[index]) forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor clearColor];
    } 
    [b setNeedsDisplay];
}

- (void)adjustButtonsToIndex:(int)index
{
    for (int i = 0; i < [buttons_ count]; i++) {
        [self switchButton:i on:NO];        
    }
    
    [self switchButton:index on:YES];
}

- (void)scheduleSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 0;
    [self didChangeValueForKey:@"selectedIndex"];
    [self adjustButtonsToIndex:0];
}

- (void)searchSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 1;
    [self didChangeValueForKey:@"selectedIndex"];
    [self adjustButtonsToIndex:1];
}

- (void)settingsSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 2;
    [self didChangeValueForKey:@"selectedIndex"];
    [self adjustButtonsToIndex:2];
}

- (void)bookmarkedSelected
{
    [self willChangeValueForKey:@"selectedIndex"];
    selectedIndex_ = 3;
    [self didChangeValueForKey:@"selectedIndex"];
    [self adjustButtonsToIndex:3];
}
@end
