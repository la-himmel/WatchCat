#import "TVShow.h"
#import "utils.h"
#import "JSONKit.h"

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


- (NSDictionary *)dictionary 
{
    DLOG("converting to dictionary CALL");
    
    NSMutableDictionary *show = [[NSMutableDictionary alloc] init];
    
    [show setValue:name_ forKey:NAME];
    [show setValue:[NSNumber numberWithInt:num_] forKey:ID];
    [show setValue:description_ forKey:DESCRIPTION];
    [show setValue:link_ forKey:LINK];
    [show setValue:image_ forKey:IMAGE];
        
    return show;
}

- (NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    if (dict == nil)
        DLOG("nil!");
    else {
        DLOG("%@ %@ %@ %@", [dict objectForKey:NAME], [dict objectForKey:LINK], [dict objectForKey:IMAGE],
             [dict objectForKey:DESCRIPTION]);
    }

    NSString *json = [dict JSONString];
    
    if (json  == nil)
        DLOG("nil!");
    
    DLOG("serialized dictionary: %@", json);
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
    DLOG("showFromDictionary: CALL");
    
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
