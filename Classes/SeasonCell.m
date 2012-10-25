#import "SeasonCell.h"

@implementation SeasonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
//    airdate_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 30)];
//    airdate_.textColor = [UIColor purpleColor];
//    airdate_.font = [UIFont systemFontOfSize:12.0];
//    airdate_.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:airdate_];
    return self;
}

- (void)setTitle:(NSString*)title
{
    self.textLabel.text = title;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor = [UIColor purpleColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
