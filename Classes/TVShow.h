
@interface TVShow: NSObject
@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *episodes;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *image;

- (NSDictionary *)dictionary;
- (NSString *)jsonString;

+ (TVShow *)showFromDictionary:(NSDictionary *)item;
+ (TVShow *)showFromJsonString:(NSString *)json;

@end
