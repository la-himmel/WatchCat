#import "ui_utils.h"

DECLARE_UI(uiTabbar) {
    CGRect buttonFrames[4];
    ui_Image buttonImages[4];
    ui_Image buttonSelectedImages[4];
    ui_Image decoration;
};

DEFINE_UI(uiTabbar) {
    .buttonFrames = {
        {  0, 0, 80, 50},
        { 80, 0, 80, 50},
        {160, 0, 80, 50},
        {240, 0, 80, 50}
    },
    .buttonImages = {
        UI_IMAGE_NAMED("favorite"),
        UI_IMAGE_NAMED("browse"),
        UI_IMAGE_NAMED("settings"),
        UI_IMAGE_NAMED("todo")
    },
    .buttonSelectedImages = {
        UI_IMAGE_NAMED("favorite_selected"),
        UI_IMAGE_NAMED("browse_selected"),
        UI_IMAGE_NAMED("settings_selected"),
        UI_IMAGE_NAMED("todo_selected")
    },
    .decoration = UI_IMAGE_NAMED("tabbar_background")
};

DEFINE_UI_END(uiTabbar)

#define uiTabbar USE_UI(uiTabbar)
