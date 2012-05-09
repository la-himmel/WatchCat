
// Sections.

#define IMPL_UI_SCHEMA_TYPE_FOR_NAME_(name) struct impl_ ## name ## _ui_schema_
#define IMPL_UI_SCHEMA_USE_FOR_NAME_(name) impl_ ## name ## _ui_use_
#define IMPL_UI_SCHEMA_STORAGE_FOR_NAME_(name) impl_ ## name ## _ui_storage_

#define IMPL_UI_DEFINITION_FOR_NAME_(name) \
    static inline IMPL_UI_SCHEMA_TYPE_FOR_NAME_(name) const *IMPL_UI_SCHEMA_USE_FOR_NAME_(name)() \
    { \
        static BOOL defined = NO; \
        static IMPL_UI_SCHEMA_TYPE_FOR_NAME_(name) IMPL_UI_SCHEMA_STORAGE_FOR_NAME_(name); \
        if (!defined) { \
            defined = YES; \
            IMPL_UI_SCHEMA_STORAGE_FOR_NAME_(name) = (IMPL_UI_SCHEMA_TYPE_FOR_NAME_(name))

#define IMPL_UI_DEFINITION_CLOSURE_FOR_NAME_(name) \
        } \
            return &(IMPL_UI_SCHEMA_STORAGE_FOR_NAME_(name)); \
    }

#define IMPL_UI_SCOPED_ALIAS(scopedName, uiPath) \
    typeof(uiPath) const (scopedName) = (uiPath); ((void)0)

// Colour.

#define IMPL_UI_COLOR_HTML(rrggbb) \
UI_COLOR_RGB((rrggbb >> 16), (rrggbb >> 8)&0xff, (rrggbb)&0xff)

struct impl_ui_color_;
extern UIColor *ui_unpackColor(struct impl_ui_color_ const *packedColor);


// Font.

struct impl_ui_font_;
extern UIFont *ui_unpackFont(struct impl_ui_font_ const *packedFont);


// Image.

#define IMPL_UI_IMAGE_STRETCHABLE_(name, lcw, tch) \
    {.imageName = (name), .leftCapWidth = (lcw), .topCapHeight = (tch)}

struct impl_ui_image_;
extern UIImage *ui_unpackImage(struct impl_ui_image_ const *packedImage);


// Localized string.
struct impl_ui_text_;
extern NSString *ui_unpackText(struct impl_ui_text_ const *packedString);


// Use the best available option to implement universal ui-object unpacking.
#if __has_feature(c_generic_selections)

#define IMPL_UNIVERSAL_UNPACK_(pack) \
    _Generic((pack), \
        ui_Color: ui_unpackColor(&(pack)), \
        ui_Font: ui_unpackFont(&(pack)), \
        ui_Image: ui_unpackImage(&(pack)), \
        ui_Text: ui_unpackText(&(pack)), \
        default: (pack))

#else

#define IMPL_UNIVERSAL_UNPACK_(pack) \
    __builtin_choose_expr(__builtin_types_compatible_p(typeof(pack), ui_Color), \
        ui_unpackColor((ui_Color const *)&(pack)), \
        __builtin_choose_expr(__builtin_types_compatible_p(typeof(pack), ui_Font), \
            ui_unpackFont((ui_Font const *)&(pack)), \
            __builtin_choose_expr(__builtin_types_compatible_p(typeof(pack), ui_Image), \
                ui_unpackImage((ui_Image const *)&(pack)), \
                __builtin_choose_expr(__builtin_types_compatible_p(typeof(pack), ui_Text), \
                    ui_unpackText((ui_Text const *)&(pack)), \
                    (pack)))))

#endif
