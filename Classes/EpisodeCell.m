#import "EpisodeCell.h"
#import "Episode.h"
#import "utils.h"

#define TAG_AIRDATE 1
@interface EpisodeCell()
@property (nonatomic, strong) UILabel *airdate;
@end

@implementation EpisodeCell
@synthesize airdate = airdate_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    airdate_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 30)];
    airdate_.textColor = [UIColor purpleColor];
    airdate_.font = [UIFont systemFontOfSize:12.0];
    airdate_.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:airdate_];
    return self;
}

- (void)setEpisode:(Episode *)episode
{
    NSString *label = [NSString stringWithFormat:@"%@ %@", episode.readableNumber, episode.name];
    self.textLabel.text = label;
    self.textLabel.backgroundColor = [UIColor clearColor];
        
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dc = [calendar components:unitFlags
                                       fromDate:date];
    NSString *currentDate = [NSString stringWithFormat:@"%d-%d-%d", dc.year, dc.month, dc.day];
//    DLOG("%@", currentDate);
    
    NSComparisonResult result = [currentDate compare:episode.airDate];
    if (result >= 0 && ![episode.airDate isEqualToString:@""]) {
        [airdate_ setText:@""];
    
        UIColor *myDarkPurple = [UIColor colorWithRed:0x65/255.0 green:0x56/255.0 blue:0x74/255.0 alpha:1.0];
        self.textLabel.textColor = myDarkPurple;
        
        UIColor *myPurple = [UIColor colorWithRed:0x60/255.0 green:0x40/255.0 blue:0x79/255.0 alpha:1.0];
        self.textLabel.highlightedTextColor = myPurple;

    } else {
        [airdate_ setText:episode.airDate];
        self.textLabel.textColor = [UIColor grayColor];
    }

}

+ (CGFloat)height
{
    return 60;
}


@end
