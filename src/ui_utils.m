#import "ui_utils.h"


static NSString *stringWithCString(char const *cString)
{
    return [NSString stringWithCString:cString
                       encoding:NSASCIIStringEncoding];
}

UIColor *ui_unpackColor(ui_Color const *packedColor)
{
    return [UIColor colorWithRed:(packedColor->r)/255.0f
                           green:(packedColor->g)/255.0f
                            blue:(packedColor->b)/255.0f
                           alpha:(packedColor->a)/255.0f];
}

UIFont *ui_unpackFont(ui_Font const *packedFont)
{
    NSString *fontName = stringWithCString(packedFont->fontName);
    return [UIFont fontWithName:fontName size:packedFont->size];
}

UIImage *ui_unpackImage(ui_Image const *packedImage)
{
    NSString *imageName = stringWithCString(packedImage->imageName);
    UIImage *image = [UIImage imageNamed:imageName];

    // Check if the image is defined as stretchable.
    if (packedImage->leftCapWidth || packedImage->topCapHeight) {
        image = [image stretchableImageWithLeftCapWidth:packedImage->leftCapWidth
                                           topCapHeight:packedImage->topCapHeight];
    }

    return image;
}

NSString *ui_unpackText(ui_Text const *packedText)
{
    switch (packedText->encoding) {
        case impl_ui_text_ascii:
            return [NSString stringWithCString:packedText->text encoding:NSASCIIStringEncoding];

        case impl_ui_text_utf8:
            return [NSString stringWithCString:packedText->text encoding:NSUTF8StringEncoding];

        case impl_ui_text_l10n: {
            NSString *stringKey = stringWithCString(packedText->text);
            return NSLocalizedString(stringKey, @"");
        }
    }
}

ui_Autoload ui_autoloadList(int listSize, int const list[listSize])
{
    // Alloc buffer for the list.  Note, that buffer is held in memory
    // indefinetely.  Buffer must end with au_None (zero) value.
    int *listBuffer = malloc(sizeof(int [listSize + 1]));
    listBuffer[listSize] = au_None;
    return memcpy(listBuffer, list, sizeof(int [listSize]));
}
