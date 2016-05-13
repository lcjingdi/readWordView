//
//  AudioPlayTool.m
//  读单词View
//
//  Created by jingdi on 16/5/13.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "AudioPlayTool.h"

@implementation AudioPlayTool
+ (void)playOriginalSoundWithUrl:(NSURL *)url completion:(void (^ __nullable)(BOOL finished))completion {
    NSLog(@"%@", @"正在播放原音...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}
+ (void)playRecordSoundWithUrl:(nonnull NSURL *)url completion:(void (^ __nullable)(BOOL finished))completion {
    NSLog(@"%@", @"正在播放录音...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}
+ (void)recordingWithURL:(nonnull NSURL *)url completion:(void (^ __nullable)(BOOL isSuccess))completion {
    NSLog(@"%@", @"正在进行录音...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}
@end
