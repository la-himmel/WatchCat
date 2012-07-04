#import "EpisodeCell.h"
#import "Episode.h"

@implementation EpisodeCell

- (void)setEpisode:(Episode *)episode
{
    NSString *label = [episode.readableNumber stringByAppendingString:episode.name];
    self.textLabel.text = label;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor = [UIColor purpleColor];
}

+ (CGFloat)height
{
    return 60;
}


@end
