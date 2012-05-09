#import "TVShow.h"

@implementation TVShow

@synthesize name = name_;
@synthesize id = id_;
@synthesize episodes = episodes_;

- (NSString *)description
{
    return [NSString stringWithFormat:@"<TVShow #%d: %@, %d eps>",
        id_, name_, [episodes_ count]];
}

@end
