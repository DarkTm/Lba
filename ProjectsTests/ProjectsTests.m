//
//  ProjectsTests.m
//  ProjectsTests
//
//  Created by Magnet on 15/6/22.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WYDelayManager.h"

@interface ProjectsTests : XCTestCase


@property (nonatomic, strong) WYDelayGCD *delayGCD;
@property (nonatomic, strong) WYDelayTimer *delayTimer;

@end

@implementation ProjectsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.delayGCD =[WYDelayGCD shareDelayGCD];
    self.delayTimer = [WYDelayTimer shareDelayTimer];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.delayGCD = nil;
    self.delayTimer = nil;
    [super tearDown];
}

- (void)testGCD {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    NSTimeInterval delay = 4 ;
    
    [self.delayGCD startWithDelay:delay task:^{
        dLog(@"");
    }];
    
    [self performSelector:@selector(timerFull:) withObject:expectation afterDelay:delay];

    [self waitForExpectationsWithTimeout:delay + 3 handler:^(NSError *error) {
        dLog(@"");
    }];
}

- (void)timerFull:(id)obj {
    [obj fulfill];
}

- (void)testTimer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    NSTimeInterval delay = 4 ;
    
    [self.delayTimer startWithDelay:delay task:^{
        dLog(@"");
    }];
    
    [self performSelector:@selector(timerFull:) withObject:expectation afterDelay:delay];
    
    [self waitForExpectationsWithTimeout:delay + 3 handler:^(NSError *error) {
        dLog(@"");
    }];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
