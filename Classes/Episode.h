
@interface Episode: NSObject
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int combinedNum;
@property (nonatomic, assign) int seasonNum;

@property (nonatomic, strong) NSString *airDate;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *readableNumber;


@end