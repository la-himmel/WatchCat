#import "ScheduleCell.h"

#import "Episode.h"

@implementation ScheduleCell

- (void)setEpisode:(Episode *)episode
{
    self.textLabel.text = episode.readableNumber;
}

+ (int)height
{
    return 42;
}

@end