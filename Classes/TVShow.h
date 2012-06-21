
@interface TVShow: NSObject
@property (nonatomic, assign) int num;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *episodes;
@property (nonatomic, strong) NSArray *description;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSURL *image;

- (NSDictionary *)dictionary;
+ (TVShow *)showFromDictionary:(NSMutableDictionary *)item;

@end
