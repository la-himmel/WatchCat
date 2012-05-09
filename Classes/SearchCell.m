#import "SearchCell.h"

#import "uiSearchCell.h"

@interface SearchCell () <UISearchBarDelegate>
@end

@implementation SearchCell

@synthesize searchBar = searchBar_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:UITableViewCellStyleDefault
                      reuseIdentifier:reuseIdentifier])) {
        return nil;
    }

    UI_SCOPED_ALIAS(ui, uiSearchCell);

    searchBar_ = [[UISearchBar alloc] initWithFrame:ui.searchBar.frame];
    [self.contentView addSubview:searchBar_];

    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
}

+ (CGFloat)height
{
    return uiSearchCell.height;
}

@end
