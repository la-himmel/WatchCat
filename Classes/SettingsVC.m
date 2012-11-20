#import "SettingsVC.h"

@interface SettingsVC ()
@property BOOL enabled;
@property (nonatomic, strong) UIButton *notifications;
@end

@implementation SettingsVC

@synthesize myseries = myseries_;
@synthesize enabled = enabled_;
@synthesize notifications = notifications_;

- (void)viewDidLoad
{
    enabled_ = true;
    
    UIImageView *back = [[UIImageView alloc] 
                         initWithFrame:CGRectMake(0, 0, 320, 356)];
    back.image = [UIImage imageNamed:@"settingsBg.png"];
    
    [self.view addSubview:back];
    self.view.backgroundColor = [UIColor whiteColor];    
 
    UIColor *myPurple = [UIColor colorWithRed:0x92/255.0 green:0x88/255.0 blue:0x96/255.0 alpha:1.0];
    UIColor *myDarkPurple = [UIColor colorWithRed:0x65/255.0 green:0x56/255.0 blue:0x74/255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    title.text = @"Local notifications";
    title.lineBreakMode = UILineBreakModeWordWrap;
    [title sizeToFit];
    title.textColor = myDarkPurple;
    title.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:title];
    
    notifications_ = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 300, 50)];
    [notifications_ setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [notifications_ setBackgroundImage:[UIImage imageNamed:@"button_active3.png"] forState:UIControlStateHighlighted];
    [notifications_ setTitle:@"Disable notifications" forState:UIControlStateNormal];
    [notifications_ setTitleColor:myPurple forState:UIControlStateNormal];
    [notifications_ addTarget:self action:@selector(toggleNotifications) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notifications_];
        
    int yOffset = 80;
    
    UILabel *about = [[UILabel alloc] initWithFrame:CGRectMake(10, 150 + yOffset, 300, 150)];
    about.text = @"Design:\nEkaterina Zhmud\n\nIdea & development:\nEkaterina Zhmud\nDmitry Ivanov";
    about.lineBreakMode = UILineBreakModeWordWrap;
    about.textAlignment = UITextAlignmentLeft;
    about.font = [UIFont systemFontOfSize:15.0];
    about.textColor = myDarkPurple;
    [about setNumberOfLines:0];
    about.backgroundColor = [UIColor clearColor];
    [self.view addSubview:about];
    
    UILabel *email1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 239 + yOffset, 300, 30)];
    email1.text = @"yekaterina.zhmud@gmail.com";
    email1.font = [UIFont systemFontOfSize:13.0];
    email1.textAlignment = UITextAlignmentRight;
    email1.textColor = myDarkPurple;
    email1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:email1];
    
    UILabel *email2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 258 + yOffset, 300, 30)];
    email2.text = @"ethercrow@gmail.com";
    email2.font = [UIFont systemFontOfSize:13.0];
    email2.textAlignment = UITextAlignmentRight;
    email2.textColor = myDarkPurple;
    email2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:email2];
}

- (void)toggleNotifications
{
    if (enabled_) {
        enabled_ = NO;
        [notifications_ setTitle:@"Enable notifications" forState:UIControlStateNormal];
    } else {
        enabled_ = YES;
       [notifications_ setTitle:@"Disable notifications" forState:UIControlStateNormal];
    }
    [myseries_ setNotificationsEnabled:enabled_];
}
@end
