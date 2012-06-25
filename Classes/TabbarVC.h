
@interface TabbarVC: UIViewController
- (id)initWithViewControllers:(NSArray *)vcs;
- (void)switchTabTo:(int)index;
@end
