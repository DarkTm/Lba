//
//  MotionEffectViewController.m
//  Projects
//
//  Created by lt on 15/9/6.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "MotionEffectViewController.h"

@interface MotionEffectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivImage;

@end

@implementation MotionEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 类似苹果springboard效果
    UIInterpolatingMotionEffect * xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue = [NSNumber numberWithFloat:-20.0];
    xEffect.maximumRelativeValue = [NSNumber numberWithFloat:20.0];
    [self.ivImage addMotionEffect:xEffect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
