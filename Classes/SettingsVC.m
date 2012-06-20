#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    UIImageView *back = [[UIImageView alloc] 
                         initWithFrame:CGRectMake(0, 0, 320, 356)];
    back.image = [UIImage imageNamed:@"settingsBg.png"];
    
    [self.view addSubview:back];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *timeZone = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
    [timeZone setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [timeZone setTitle:@"Time zone" forState:UIControlStateNormal];
    [timeZone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:timeZone];
    
    UIButton *notificationType = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, 300, 50)];
    [notificationType setTitle:@"Notification type" forState:UIControlStateNormal];
    [notificationType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notificationType setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.view addSubview:notificationType];
}

@end
