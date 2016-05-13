/**
 *  播放在线和本地音频
 *
 */

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@interface EKWAudioManager : NSObject<AVAudioPlayerDelegate>


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





typedef void (^progressBlock)(CGFloat currTime, CGFloat duration, NSError * _Nullable error, BOOL finished, EKWAudioManager * _Nullable manager);

+(_Nullable instancetype)sharedManager;

@property (nonatomic, strong, nullable) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong, nullable) AVPlayer *player;

/**
 *  播放本地音频1
 *
 *  @param filePath 音频路径
 *  @param block    blcok
 */
-(void)startLocalWithName:(nullable NSString *) filePath block:(nullable progressBlock)block;

/**
 *  播放本地音频2
 *
 *  @param filePath 本地音频路径
 *  @param toTime   跳转到的时间
 *  @param block    block
 */
-(void)startLocalWithName:(nullable NSString *)filePath toTime:(float) toTime  block:(nullable progressBlock)block;

/**
 *  播放在线音频1
 *
 *  @param url   在线音频url
 *  @param block block
 */
-(void)startOnLineWithURL:(nullable NSString *)url block:(nullable progressBlock)block;

/**
 *  播放在线音频2
 *
 *  @param url   在线音频url
 *  @param oTime 在线播放超时时间
 *  @param block block
 */
- (void)startOnLineWithURL:(nullable NSString *) url timeOut:(float) oTime block:(nullable progressBlock) block;


/**
 *  暂停方法
 */
-(void)pause;

/**
 *  暂停恢复
 */
-(void)resume;

/**
 *  停止
 */
-(void)stop;

/**
 *  重新播放
 */
-(void)restart;


-(void)changeVolumeToValue:(CGFloat)volume;
-(void)changeSpeedToRate:(CGFloat)rate;
-(void)moveToSecond:(float)second;
-(void)moveToSection:(CGFloat)section;

@end

@interface NSTimer (Blocks)

+(nullable id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^_Nullable)())inBlock repeats:(BOOL)inRepeats;
+(nullable id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^_Nullable)())inBlock repeats:(BOOL)inRepeats;

@end

@interface NSTimer (Control)

-(void)pauseTimer;
-(void)resumeTimer;

@end