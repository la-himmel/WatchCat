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
#define IDSTRING @"id_string"
#define NEAREST_DATE @"nearest_date"
#define NEAREST_ID @"nearest_id"

@synthesize name = name_;
@synthesize episodes = episodes_;
@synthesize description = description_;
@synthesize link = link_;
@synthesize image = image_;
@synthesize status = status_;
@synthesize idString = idString_;
@synthesize nearestId = nearestId_;
@synthesize nearestAirDate = nearestAirDate_;


- (NSDictionary *)dictionary 
{
    NSMutableDictionary *show = [[NSMutableDictionary alloc] init];
    
    [show setValue:name_ forKey:NAME];
    [show setValue:description_ forKey:DESCRIPTION];
    [show setValue:link_ forKey:LINK];
    [show setValue:image_ forKey:IMAGE];
    [show setValue:status_ forKey:STATUS];
    [show setValue:idString_ forKey:IDSTRING];
    [show setValue:nearestId_ forKey:NEAREST_ID];
    [show setValue:nearestAirDate_ forKey:NEAREST_DATE];

    DLOG("nearest episode: %@ %@", nearestId_, [nearestAirDate_ description]);        
    return show;
}

- (NSString *)jsonString
{
    NSDictionary *dict = [self dictionary];
    if (dict == nil)
        DLOG("dictionary is nil!");
   
    NSString *json = [dict JSONString];
    
    if (json  == nil)
        DLOG("json string is nil!");
    
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
    show.description = [item valueForKey:DESCRIPTION];
    show.link = [item valueForKey:LINK];
    show.image = [item valueForKey:IMAGE];
    show.status = [item valueForKey:STATUS];
    show.idString = [item valueForKey:IDSTRING];
    show.nearestAirDate = [item valueForKey:NEAREST_DATE];
    show.nearestId = [item valueForKey:NEAREST_ID];
    
    DLOG("nearest episode: %@ %@", show.nearestId, [show.nearestAirDate description]);  
    
    return show;
}



@end
