//
//  GCDViewController.m
//  Projects
//
//  Created by lt on 16/2/3.
//  Copyright © 2016年 ikefou.com. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
{
    dispatch_source_t _processingQueueSource;
}
@property (atomic, assign, getter=isRunning) BOOL running;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@end

@implementation GCDViewController

#define LTFUNC         NSLog(@"%s [line : %d]" ,__func__ , __LINE__);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self source];
//    });
    [self semaphore];
}

- (void)semaphore {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        dispatch_async(queue, ^(){
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//
            NSLog(@"addd :%d", index);
            sleep(1);
            [array addObject:[NSNumber numberWithInt:index]];
            dispatch_semaphore_signal(semaphore);
        });
    }
    LTFUNC;
}

// 可做计时
- (void)source {

    _processingQueueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    __block NSUInteger total = 0;
    dispatch_source_set_event_handler(_processingQueueSource, ^{
       
        NSUInteger value = dispatch_source_get_data(_processingQueueSource);
        total += value;
        self.lblNumber.text = [NSString stringWithFormat:@"%ld",total];
        NSLog(@"进度：%@", @((CGFloat)total/100));
        NSLog(@"🔵线程号：%@", [NSThread currentThread]);
    });
    
    
    dispatch_resume(_processingQueueSource);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (NSUInteger idx = 0; idx < 1000; idx++) {
        dispatch_async(queue, ^{
            dispatch_source_merge_data(_processingQueueSource, 1);
            NSLog(@"♻️线程号：%@", [NSThread currentThread]);
            usleep(100000);
        });
    }
}

- (void) resumeQueue{
    dispatch_queue_t queue1 = dispatch_queue_create("com.lt.queue1", 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.lt.queue2", 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(queue1, ^{
        NSLog(@"任务 1 ： queue 1...");
        sleep(1);
        NSLog(@"✅完成任务 1");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"任务 1 ： queue 2...");
        sleep(1);
        NSLog(@"✅完成任务 2");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"🚫正在暂停 1");// 任务放到queue1中做
        
        dispatch_suspend(queue1);
    });
    dispatch_group_async(group, queue2, ^{
        NSLog(@"🚫正在暂停 2");
        dispatch_suspend(queue2);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"＝＝＝＝＝＝＝等待两个queue完成, 再往下进行...");
    dispatch_async(queue1, ^{
        NSLog(@"任务 2 ： queue 1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"任务 2 ： queue 2");
    });
    NSLog(@"🔴为什么这个NSLog会在上面两个NSLog之前打印❓❓答：dispatch_suspend的作用‼️");
    
    dispatch_resume(queue1);
    dispatch_resume(queue2);
}

// 同步 && 异步
- (void)concurrent {
    dispatch_queue_t ltq = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(ltq, ^{
        LTFUNC
        sleep(2);
    });
    dispatch_async(ltq, ^{
        LTFUNC
    });

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
