//
//  Created by lt on 15/8/11.
//  Copyright (c) 2015年 com.ikefou All rights reserved.
//

#import "WYRadiusBorderView.h"


@interface WYRadiusBorderView ()

//@property (assign, nonatomic) BOOL    wyp_topRightRadius;
//@property (assign, nonatomic) BOOL    wyp_topLeftRadius;
//@property (assign, nonatomic) BOOL    wyp_bottomRightRadius;
//@property (assign, nonatomic) BOOL    wyp_bottomLeftRadius;


@property (assign, nonatomic) CGFloat wyp_cornerRadius;
@property (assign, nonatomic) CGFloat wyp_boardWidth;
@property (strong, nonatomic) UIColor *wyp_boardColor;


@end

@implementation WYRadiusBorderView

- (void)setBorderColor:(UIColor *)borderColor {
    self.wyp_boardColor = borderColor;
    self.layer.borderColor = self.wyp_boardColor.CGColor;
    self.layer.borderWidth = self.wyp_boardWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.wyp_boardWidth = borderWidth;
    self.layer.borderWidth = self.wyp_boardWidth;
    self.layer.borderColor = self.wyp_boardColor.CGColor;
}

- (void)setWy_cornerRadius:(CGFloat)wy_cornerRadius {
    self.layer.cornerRadius = wy_cornerRadius;
    self.layer.masksToBounds = YES;
}
/*
- (void)setWy_cornerRadius:(CGFloat)wy_cornerRadius {
    self.wyp_cornerRadius = wy_cornerRadius;
    [self wyRaiusBuild];
}

- (void)setTopLeftRadius:(BOOL)topLeftRadius {
    self.wyp_topLeftRadius = topLeftRadius;
    [self wyRaiusBuild];
}

- (void)setTopRightRadius:(BOOL)topRightRadius {
    self.wyp_topRightRadius = topRightRadius;
    [self wyRaiusBuild];
}

- (void)setBottomLeftRadius:(BOOL)bottomLeftRadius {
    self.wyp_bottomLeftRadius = bottomLeftRadius;
    [self wyRaiusBuild];
}

- (void)setBottomRightRadius:(BOOL)bottomRightRadius {
    self.wyp_bottomRightRadius = bottomRightRadius;
    [self wyRaiusBuild];
}

- (void)wyRaiusBuild {


    
    UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:self.frame byRoundingCorners:((self.wyp_bottomLeftRadius ? UIRectCornerBottomLeft : 0) |
                                                                                              (self.wyp_bottomRightRadius ? UIRectCornerBottomRight : 0) |
                                                                                              (self.wyp_topRightRadius ? UIRectCornerTopRight : 0)  |
                                                                                              (self.wyp_topLeftRadius ? UIRectCornerTopLeft : 0))
                                                   cornerRadii:CGSizeMake(self.wyp_cornerRadius, self.wyp_cornerRadius)];

    if (self.layer.mask) {
        CALayer *layer = self.layer.mask;
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *maskLayer = (CAShapeLayer *)layer;
            maskLayer.frame = self.bounds;
            maskLayer.path = bp.CGPath;
            maskLayer.mask = maskLayer;
        }
        else {
            NSLog(@"自有masklayer不错处理");
        }
    }
    else {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = bp.CGPath;
        self.layer.mask = maskLayer;
    }
}
*/
@end
