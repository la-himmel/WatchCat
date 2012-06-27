#import "TVShow.h"
#import "utils.h"
#import "JSONKit.h"

@implementation TVShow

#define NAME @"name"
#define ID @"id"
#define DESCRIPTION @"description"
#define LINK @"link"
#define IMAGE @"image"
#define STATUS @"status"

@synthesize name = name_;
@synthesize num = num_;
@synthesize episodes = episodes_;
@synthesize description = description_;
@synthesize link = link_;
@synthesize image = image_;
@synthesize status = status_;
@synthesize nearestEpisode = nearestEpisode_;


- (NSDictionary *)dictionary 
{
    NSMutableDictionary *show = [[NSMutableDictionary alloc] init];
    
    [show setValue:name_ forKey:NAME];
    [show setValue:[NSNumber numberWithInt:num_] forKey:ID];
    [show setValue:description_ forKey:DESCRIPTION];
    [show setValue:link_ forKey:LINK];
    [show setValue:image_ forKey:IMAGE];
    [show setValue:status_ forKey:STATUS];
        
    return show;
}

- (NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    if (dict == nil)
        DLOG("nil!");
    else {
//        DLOG("%@ %@ %@ %@", [dict objectForKey:NAME], [dict objectForKey:LINK], [dict objectForKey:IMAGE],
//             [dict objectForKey:DESCRIPTION]);
    }

    NSString *json = [dict JSONString];
    
    if (json  == nil)
        DLOG("nil!");
    
    return json;    
}

+ (TVShow *)showFromJsonString:(NSString *)json
{
    NSDictionary *item = [json objectFromJSONString];
    
    TVShow *show = [TVShow showFromDictionary:item];
    return show;    
}

+ (TVShow *)showFromDictionary:(NSDictionary *)item
{
    TVShow *show = [[TVShow alloc] init];
    show.name = [item valueForKey:NAME];
    NSNumber *num = [item valueForKey:ID];
    show.num = (int)num;
    show.description = [item valueForKey:DESCRIPTION];
    show.link = [item valueForKey:LINK];
    show.image = [item valueForKey:IMAGE];
    show.status = [item valueForKey:STATUS];
    
    return show;
}



@end
