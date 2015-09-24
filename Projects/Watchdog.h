//
//  Watchdog.h
//  
//
//  Created by lt on 15/9/24.
//
//

#import <Foundation/Foundation.h>

@interface Watchdog : NSObject

+ (instancetype)instance;
- (instancetype)initWithThreshold:(CGFloat) threshold;

@end
