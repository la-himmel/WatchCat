#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC
@synthesize myseries = myseries_;

- (void)viewDidLoad
{
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
    
    UIButton *timeZone = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 300, 50)];
    [timeZone setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [timeZone setTitle:@"Enable notifications" forState:UIControlStateNormal];
    [timeZone setTitleColor:myPurple forState:UIControlStateNormal];
    [self.view addSubview:timeZone];
    
//    UIButton *notificationType = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
//    [notificationType setTitle:@"Disable notifications" forState:UIControlStateNormal];
//    [notificationType setTitleColor:myDarkPurple forState:UIControlStateNormal];
//    [notificationType setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [self.view addSubview:notificationType];
    
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

@end
