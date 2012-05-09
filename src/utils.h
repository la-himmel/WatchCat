#ifndef NDEBUG
#   define DLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __func__, __LINE__, ##__VA_ARGS__)
#else
#   define DLOG(...)
#endif

#define COLOR_RGB(R, G, B) [UIColor colorWithRed:(float)(R)/255\
                                           green:(float)(G)/255\
                                            blue:(float)(B)/255\
                                           alpha:1.0]

#define COLOR_GREY(Y) COLOR_RGB(Y, Y, Y)

#define COLOR_RGBA(R, G, B, A) [UIColor colorWithRed:(float)(R)/255\
    green:(float)(G)/255\
    blue:(float)(B)/255\
    alpha:(float)(A)/255]

#define L10N(s) NSLocalizedString(@"L10N_" s, @"")

// Build @synthesize x = x_; clause for single ivar.  This macro is intended
// to enforce ivar naming convention (trailing underscore).  Its usage is
// pure optional, however.
#define SYNTHESIZE_IVAR(x) @synthesize x = x ## _
