//
//  UIBezierPath+TextPath.h
//  Projects
//
//  Created by lt on 15/8/28.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (TextPath)

+ (CGPathRef)pathRefFromText:(NSAttributedString *)aString;

@end
