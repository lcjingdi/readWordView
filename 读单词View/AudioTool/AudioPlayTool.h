//
//  AudioPlayTool.h
//  读单词View
//
//  Created by jingdi on 16/5/13.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayTool : NSObject

///  播放原音
///
///  @param url        原音的音频地址
///  @param completion 完成回调
+ (void)playOriginalSoundWithUrl:(nonnull NSURL *)url completion:(void (^ __nullable)(BOOL finished))completion;
///  播放录音
///
///  @param url        录音的音频地址
///  @param completion 完成回调
+ (void)playRecordSoundWithUrl:(nonnull NSURL *)url completion:(void (^ __nullable)(BOOL finished))completion;
///  进行录音
///
///  @param url        录音存放的地址
///  @param completion 录音回调
+ (void)recordingWithURL:(nonnull NSURL *)url completion:(void (^ __nullable)(BOOL isSuccess))completion;
@end
