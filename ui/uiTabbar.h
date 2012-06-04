#import "ui_utils.h"

DECLARE_UI(uiTabbar) {
    CGRect buttonFrames[4];
    ui_Image buttonImages[4];
    ui_Image buttonSelectedImages[4];
    ui_Image background;
};

DEFINE_UI(uiTabbar) {
    .buttonFrames = {
        {  0, 0, 80, 50},
        { 80, 0, 80, 50},
        {160, 0, 80, 50},
        {240, 0, 80, 50}
    },
    .buttonImages = {
        UI_IMAGE_NAMED("tabbar_favorite"),
        UI_IMAGE_NAMED("tabbar_browse"),
        UI_IMAGE_NAMED("tabbar_settings"),
        UI_IMAGE_NAMED("tabbar_todo")
    },
    .buttonSelectedImages = {
        UI_IMAGE_NAMED("tabbar_favorite_selected"),
        UI_IMAGE_NAMED("tabbar_browse_selected"),
        UI_IMAGE_NAMED("tabbar_settings_selected"),
        UI_IMAGE_NAMED("tabbar_todo_selected")
    },
    .background = UI_IMAGE_NAMED("tabbar_background")
};

DEFINE_UI_END(uiTabbar)

#define uiTabbar USE_UI(uiTabbar)
