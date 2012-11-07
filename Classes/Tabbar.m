#import "Tabbar.h"

#import "utils.h"
#import "uiTabbar.h"

#import "AnimatedButton.h"

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
    
    for (int i = 0; i < (sizeof(ui.buttonFrames)/sizeof(ui.buttonFrames[0])); ++i) {
        AnimatedButton *b = [[AnimatedButton alloc] init];
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
        
        b.image = uu(ui.buttonImages[i]);
        b.selectedImage = uu(ui.buttonSelectedImages[i]);
        b.overlayImage = [UIImage imageNamed:@"tabbar_paw_white"];

        [self addSubview:b];
        [buttons_ addObject:b];
    }

    UIImageView *decoration = [[UIImageView alloc] initWithFrame:self.bounds];
    decoration.image = uu(ui.decoration);
    DLOG("decoration.image = %@", decoration.image);
    [self addSubview:decoration];

    return self;
}

- (void)switchButton:(int)index on:(BOOL)on
{
//    DLOG("adjust button: %d %@", index, on ? @"true" : @"false");
    AnimatedButton *b = [buttons_ objectAtIndex:index];
    
    [b setSelected:on];
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
