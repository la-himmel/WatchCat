#import "ui_utils.h"

DECLARE_UI(uiSearchCell) {
    nested_ui_UIView("") searchBar;
    CGFloat height;
};

DEFINE_UI(uiSearchCell) {
    .searchBar = {
        .frame = {0, 2, 320, 36}
    },
    .height = 40
};

DEFINE_UI_END(uiSearchCell)

#define uiSearchCell USE_UI(uiSearchCell)
