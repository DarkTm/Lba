//
//  PathAnimationView.m
//
//  Code generated using QuartzCode on 15/9/15.
//  www.quartzcodeapp.com
//

#import "PathAnimationView.h"

#define kAnimationTime 1

@interface PathAnimationView ()

@property (nonatomic, strong) CAShapeLayer *animation;
@property (nonatomic, strong) CAShapeLayer *leftTop;
@end

@implementation PathAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupLayers];
    }
    return self;
}


- (void)setupLayers{
    CGColorRef fillColor = [UIColor clearColor].CGColor;
    CGColorRef strokenColor  = [UIColor redColor].CGColor;
    CAShapeLayer * roundedrect = [CAShapeLayer layer];
    roundedrect.frame     = CGRectMake(20, 20, 40, 40);
    roundedrect.fillColor = [UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1].CGColor;
    roundedrect.lineWidth = 2;
    roundedrect.strokeColor = strokenColor;
    roundedrect.path      = [self roundedRectPath].CGPath;
    [self.layer addSublayer:roundedrect];
    roundedrect.strokeStart = 0.0f;
    roundedrect.strokeEnd = 0.1f;
    self.animation = roundedrect;
    
    CAShapeLayer * roundedrect1 = [CAShapeLayer layer];
    roundedrect1.frame     = CGRectMake(26, 20, 18, 20);
    roundedrect1.lineWidth = 2;
    roundedrect1.fillColor = fillColor;
    roundedrect1.strokeColor = strokenColor;
    roundedrect1.path      = [self defPath].CGPath;
    [self.layer addSublayer:roundedrect1];
    roundedrect1.strokeStart = 0;
    roundedrect1.strokeEnd = 0.0;
    self.leftTop = roundedrect1;
}


- (IBAction)startAllAnimations:(id)sender{
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    if (newSuperview) {
        NSDictionary *value = [self animationAnimation];
        [self.leftTop addAnimation:value[@"sign"] forKey:@"132"];
        [self.animation addAnimation:value[@"group"] forKey:@"asfsd"];
    }
}

- (CAAnimation *)ani {
    CABasicAnimation * positionAnim2  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    positionAnim2.fromValue           = @(0);
    positionAnim2.toValue             = @(0.2);
    positionAnim2.duration            = kAnimationTime * 0.1;
    positionAnim2.beginTime           = kAnimationTime * 0.9 + CACurrentMediaTime();
    positionAnim2.removedOnCompletion = YES;
    positionAnim2.delegate = self;
    return positionAnim2;
}

- (void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.leftTop addAnimation:[self ani] forKey:@"132"];
    }
}

- (NSDictionary *)animationAnimation {
    
    CABasicAnimation * positionAnim          = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    positionAnim.fromValue                   = @(0);
    positionAnim.toValue                     = @(1);

    CABasicAnimation * positionAnim1          = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    positionAnim1.fromValue                   = @(0.1);
    positionAnim1.toValue                     = @(1.1);
    
    CAAnimationGroup *roundedrectAnimGroup   = [CAAnimationGroup animation];
    roundedrectAnimGroup.animations          = @[positionAnim,positionAnim1];
    roundedrectAnimGroup.fillMode            = kCAFillModeForwards;
    roundedrectAnimGroup.removedOnCompletion = NO;
    roundedrectAnimGroup.repeatCount         = FLT_MAX;
    roundedrectAnimGroup.duration            = kAnimationTime;
    
    NSDictionary *rslt = @{@"group":roundedrectAnimGroup,@"sign":[self ani]};
    
    return rslt;
}

#pragma mark - Bezier Path

- (UIBezierPath*)roundedRectPath{
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 40, 40) cornerRadius: 4];
    [UIColor.grayColor setFill];
    [rectanglePath fill];
    return rectanglePath;
}

- (UIBezierPath*)defPath{
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 18, 20)];
    return rectanglePath;
}

@end