#import <UIKit/UIKit.h>

#import "ui_utils_impl.h"


/* Declare a ui schema with specified name.

 Example:
 DECLARE_UI(uiTest)
 {
    CGRect testFrame;
    CGRect[2] sectionFrames;
    CGFloat testHeight;
    PackedFont testFont;
    PackedColor testColor;
    PackedColor testBackgroundColor;
 };

 */
#define DECLARE_UI(schema) \
    IMPL_UI_SCHEMA_TYPE_FOR_NAME_(schema)

/* Define a ui schema with specified name.

 Example (with bogus data):
 DEFINE_UI(uiTest)
 {
    .testFrame = {320, 0, 694, 39},
    .sectionFrames = {
        [0] = {0, 76, 704, 672},
        [1] = {8, 18, 208, 129}},
    .testHeight = 187,
    .testFont = UI_FONT("Helvetica", 16.0f),
    .testColor = UI_COLOR_RGB(0x12, 0x23, 0x34),
    .testBackgroundColor = UI_COLOR_HTML(00cafe)
 };

 */
#define DEFINE_UI(schema) \
    IMPL_UI_DEFINITION_FOR_NAME_(schema)

#define DEFINE_UI_END(schema) \
    IMPL_UI_DEFINITION_CLOSURE_FOR_NAME_(schema)

#define USE_UI(schema) (*IMPL_UI_SCHEMA_USE_FOR_NAME_(schema)())


/* Define scoped alias for ui fragment.

 This macro creates new name for a ui fragment in block scope.  Fragment may
 be whole ui schema or selected part of it.  Scoped name cannot be used outside
 of scope it is declared in.  Also, it cannot be declare in global scope.

 Example:

 {
    // Load result list for landscape orientation.
    UI_SCOPED_ALIAS(listUi, uiResultList.landscape.top.list)

    listView = [[ListView alloc] initWithFrame:listUi.frame];
    ...
 }

*/
#define UI_SCOPED_ALIAS(scopedName, uiPath) \
    IMPL_UI_SCOPED_ALIAS(scopedName, uiPath)


/* Nest ui description inside another.

 Example:
 DECLARE_UI(uiTest)
 {
    CGRect testFrame;
    nested_ui(table common) {
        CGRect tableFrame;
    } table;
    nested_ui(table cell) {
        CGRect pictureFrame;
    } cell;
 }

 Do not forget curly braces.

 */
#define nested_ui(...) const struct

/* Define auxiliary functions to calculate some ui properties.

 Some ui properties may be calculated efficienlty for series of objects.  For
 those cases an auxiliary function may be defined and set on ui definition.
 You may use arbitrary code, local variables, calculate random colors, etc.  It's
 much better overall than macros with arguments.

 Example:

   UI_FUNC CGRect listItemFrame(int i)
   {
       return (CGRect){10, 10 + 24*i, 186, 24};
   }

 Declaration will be:
   nested_ui("list item") {
       ...
       CGRect (*frameFunc)(int);
   }

 Definition:
   ...
   .frameFunc = listItemFrame,

 */
#define UI_FUNC static

// Stubs.

// This constant says that the parameter is set automatically via internals.
#define UI_AUTO 0.0f


/* Special UI types and constructors.

 Types:
    ui_Color -- packed colour;
    ui_Font -- packed font;
    ui_Image -- image from app bundle;
    ui_LString -- localized string.

 Constructors:

  ui_Color:
    UI_COLOR_RGBA(r, g, b, a)
    UI_COLOR_RGB(r, g, b)
    UI_COLOR_HTML(rrggbb)  *accepts 6 hexadecimal digits

  ui_Font:
    {.fontName = "name", .size = size}  *recommended
    UI_FONT(name, size)

  ui_Image:
    {.imageName = "name"}
    {.imageName = "name", .leftCapWidth = w, .topCapHeight = h}
    UI_IMAGE_NAMED(name)
    UI_IMAGE_STRETCHABLE(name, leftCapWidth, topCapHeight)

  ui_Text:
    UI_ASCII_STRING("ASCII text for test purposes")
    UI_UTF8_STRING("utf8 text for test purposes")  *rare
    UI_L10N_STRING("STRING_KEY")
    UI_L10N_STRING("STRING_KEY", "Comment")  *rare

 Use uu(packedValue) macro to unpack either of these values to UIColor, UIFont,
 UIImage, NSString instances.

*/

// Colour.

typedef struct impl_ui_color_ {
    CGFloat r, g, b, a;
} ui_Color;

#define UI_COLOR_RGBA(R, G, B, A) {.r = (R), .g = (G), .b = (B), .a = (A)}
#define UI_COLOR_RGB(r, g, b) UI_COLOR_RGBA((r), (g), (b), 255)
#define UI_COLOR_HTML(code) IMPL_UI_COLOR_HTML(0x ## code)

// Shorthand macro for "unpack colour".
// Note: in most cases use uu(packedColour) instead.
#define ui_uc(packedColor) ui_unpackColor(&(packedColor))

// Font.

typedef struct impl_ui_font_ {
    char *fontName;
    CGFloat size;
} ui_Font;

#define UI_FONT(fName, fSize) {.fontName = (fName), .size = (fSize)}


// Image.
typedef struct impl_ui_image_ {
    char *imageName;
    NSInteger leftCapWidth;
    NSInteger topCapHeight;
} ui_Image;

#define UI_IMAGE_NAMED(name) {.imageName = (name), .leftCapWidth = 0, .topCapHeight = 0}

#define UI_IMAGE_STRETCHABLE(name, leftCapWidth, topCapHeight) \
    IMPL_UI_IMAGE_STRETCHABLE_(name, leftCapWidth, topCapHeight)


// Localizable string.
typedef struct impl_ui_text_ {
    char *text;
    enum {
        impl_ui_text_ascii,
        impl_ui_text_utf8,
        impl_ui_text_l10n
    } encoding;
} ui_Text;

#define UI_ASCII_STRING(ascii) {.text = (ascii), .encoding = impl_ui_text_ascii}
#define UI_UTF8_STRING(utf8) {.text = (utf8), .encoding = impl_ui_text_utf8}
#define UI_L10N_STRING(ascii, ...) {.text = ("L10N_" ascii), .encoding = impl_ui_text_l10n}


// Universal unpack (hence "uu").  It unpacks either of ui_Color, ui_Font,
// ui_Image by resolving types at compile-time.

#define uu(pack) IMPL_UNIVERSAL_UNPACK_(pack)


/* Convenience nested declarations for standard controls.

 They might be used instead of nested_ui(...) { ... } part of nested declaration.

 Don't use them though, for they may add redundant properties and pollute the
 namespace.
*/

// Autoload facility definitions.

typedef int const *ui_Autoload;
ui_Autoload ui_autoloadList(int, int const []);  // Do not call directly.

// Wrapper to allocate autoload identifiers somewhere in memory.  List of
// identifiers is zero-terminated list of integers.
#define ui_au(...)  ui_autoloadList(sizeof((int []){__VA_ARGS__})/sizeof(int), \
    (int const []){__VA_ARGS__})

// UIView.
struct ui_NestedUIView {
    ui_Autoload autoload;
    CGRect frame;
    ui_Color backgroundColor;
    UIViewAutoresizing autoresizingMask;
    UIViewContentMode contentMode;
};

#define nested_ui_UIView(...) nested_ui(__VA_ARGS__) ui_NestedUIView


// UIView.
struct ui_NestedUITextField {
    ui_Autoload autoload;
    CGRect frame;
    ui_Font font;
    ui_Color textColor;
};

#define nested_ui_UITextField(...) nested_ui(__VA_ARGS__) ui_NestedUITextField


// UILabel.
struct ui_NestedUILabel {
    ui_Autoload autoload;
    CGRect frame;
    ui_Color backgroundColor;
    UIViewAutoresizing autoresizingMask;
    UITextAlignment textAlignment;
    ui_Text text;
    ui_Color textColor;
    ui_Font font;
    int numberOfLines;
};

#define nested_ui_UILabel(...) nested_ui(__VA_ARGS__) ui_NestedUILabel


// UIImageView.
struct ui_NestedUIImageView {
    ui_Autoload autoload;
    CGRect frame;
    // (omitted intentionally) ui_Color backgroundColor;
    UIViewAutoresizing autoresizingMask;
    UIViewContentMode contentMode;
    ui_Image image;
};

#define nested_ui_UIImageView(...) nested_ui(__VA_ARGS__) ui_NestedUIImageView


// UIButton (very partially).
struct ui_NestedUIButton {
    ui_Autoload autoload;

    CGRect frame;
    ui_Color backgroundColor;
    UIViewAutoresizing autoresizingMask;
    UIViewContentMode contentMode;

    ui_Font font;

    // For normal control state.
    ui_Text title;
    ui_Color titleColor;
    ui_Image image;
    ui_Image backgroundImage;

    // Values for other states (selected, highlighted) are not defined.
};

#define nested_ui_UIButton(...) nested_ui(__VA_ARGS__) ui_NestedUIButton


/* Autoloaded property identifiers.
  
  Autoload identifier starts with "au_".
*/

enum au_Properties {
    // None is used as terminator for list of autoloaded properties.
    au_None = 0,

    // Common UIView.
    au_Frame,
    au_BackgroundColor,
    au_AutoresizingMask,
    au_ContentMode,

    // UILabel.
    au_Text,
    au_TextAlignment,
    au_TextColor,
    au_Font,
    au_NumberOfLines,

    // TODO: UITextField.
    // UIImageView.
    au_Image,

    // UIButton.
    au_Title,
    au_TitleColor,
    // au_Image,
    au_BackgroundImage,
};