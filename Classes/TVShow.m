#import "TVShow.h"
#import "utils.h"

@implementation TVShow

#define NAME @"name"
#define ID @"id"
#define DESCRIPTION @"description"
#define LINK @"link"
#define IMAGE @"image"

@synthesize name = name_;
@synthesize num = num_;
@synthesize episodes = episodes_;
@synthesize description = description_;
@synthesize link = link_;
@synthesize image = image_;


- (NSMutableDictionary *)dictionary 
{
    DLOG("converting to dictionary...");
    
    NSMutableDictionary *show = [[NSMutableDictionary alloc] init];
    
    [show setValue:name_ forKey:NAME];
    [show setValue:[NSNumber numberWithInt:num_] forKey:ID];
    [show setValue:description_ forKey:DESCRIPTION];
    [show setValue:link_ forKey:LINK];
    [show setValue:image_ forKey:IMAGE];
    
    return show;
}

+ (TVShow *)showFromDictionary:(NSMutableDictionary *)item
{
    TVShow *show = [[TVShow alloc] init];
    show.name = [item valueForKey:NAME];
    NSNumber *num = [item valueForKey:ID];
    show.num = (int)num;
    show.description = [item valueForKey:DESCRIPTION];
    show.link = [item valueForKey:LINK];
    show.image = [item valueForKey:IMAGE];
    
    return show;
}



@end
