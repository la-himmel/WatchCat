#import "Episode.h"

@interface TVShow: NSObject
@property (nonatomic, strong) NSArray *episodes;
@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *nearestAirDate;
@property (nonatomic, strong) NSString *nearestId;
@property (nonatomic, strong) NSString *lastScheduled;

- (NSDictionary *)dictionary;
- (NSString *)jsonString;

+ (TVShow *)showFromDictionary:(NSDictionary *)item;
+ (TVShow *)showFromJsonString:(NSString *)json;

@end
