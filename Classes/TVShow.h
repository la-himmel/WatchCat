
@interface TVShow: NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *episodes;
@property (nonatomic, strong) NSArray *description;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSURL *image;

@end
