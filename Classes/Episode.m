#import "Episode.h"

@implementation Episode

@synthesize num = num_;
@synthesize combinedNum = combinedNum_;
@synthesize seasonNum = seasonNum_;

@synthesize airDate = airDate_;
@synthesize name = name_;

@synthesize description = description_;
@synthesize image = image_;
@synthesize readableNumber = readableNumber_;

- (NSString *)readableNumber
{
    NSString *readable = [NSString stringWithFormat:@"s%de%d", seasonNum_, combinedNum_];
    return readable;
}

@end