#import "EKWAudioManager.h"

typedef NS_ENUM(NSUInteger, PlayRadioType) {
    PlayRadioTypeOriginal,      // 原音
    PlayRadioTypeRecord,        // 录音
};

@interface EKWAudioManager ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSTimer *priTimer;
@property (nonatomic, strong) NSTimer *timeOutTimer;

@property (nonatomic, strong) NSNotificationCenter *addNotic;
@property (nonatomic, strong) NSMutableDictionary *mutBlock;

@property (nonatomic, assign) CGFloat currentPlan;           //是否
@property (nonatomic, assign) BOOL finishPlay;


@end

@implementation EKWAudioManager

static NSString *_bKeyString = @"blockKey";

+(instancetype)sharedManager {
    
    static EKWAudioManager *soundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundManager = [[self alloc]init];
    });
    
    return soundManager;
}

- (id)init
{
    if (self = [super init]) {
        self.addNotic = [NSNotificationCenter defaultCenter];
        self.mutBlock = [NSMutableDictionary dictionary];
    }
    return self;
}

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

#pragma mark - private method

+ (void)playOfflineOriginalSoundWithUrl:(NSURL *)url playType:(PlayRadioType)playType completion:(void (^ __nullable)(BOOL finished))completion {
    
}
+ (void)playOnlineOriginalSoundWithUrl:(NSURL *)url playType:(PlayRadioType)playType completion:(void (^ __nullable)(BOOL finished))completion {
    
}

#pragma mark -- function

-(void)startLocalWithName:(NSString *) filePath block:(progressBlock)block;
{
    [self startLocalWithName:filePath toTime:0 block:block];
}

-(void)startLocalWithName:(NSString *)filePath toTime:(float) toTime  block:(progressBlock)block
{
    NSError *error = nil;
    
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    if (toTime>0) {//解决离线音频，课文跟读重音问题
        [_audioPlayer setCurrentTime:toTime];
    }
    [_audioPlayer play];
    
    
    _finishPlay = NO;
    
    [self finishTimer];
    [self.mutBlock removeAllObjects];
    
    if (block) {
        [self.mutBlock setObject:[block copy] forKey:_bKeyString];
    }
    
    
    self.priTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(priOffLineComeOnTimer:) userInfo:error repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.priTimer forMode:NSRunLoopCommonModes];
}

- (void) onLinePlayerOver:(NSNotification *) notification
{
    AVPlayerItem *currItem = (AVPlayerItem *)notification.object;
    
    if (currItem == self.player.currentItem) {
        
        self.finishPlay = YES;
    }
}

-(void)startOnLineWithURL:(NSString *)url block:(progressBlock)block;
{
    [self startOnLineWithURL:url timeOut:0 block:block];
}

- (void)startOnLineWithURL:(NSString *) url timeOut:(float) oTime block:(progressBlock) block
{
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:anItem];
    }else{
        self.player = [AVPlayer playerWithPlayerItem:anItem];
    }
    
    [self.player play];
    [self priAddObserver];
    
    self.finishPlay = NO;
    [self.mutBlock removeAllObjects];
    
    if (block) {
        [self.mutBlock setObject:[block copy] forKey:_bKeyString];
    }
    
    self.currentPlan = 0.0;
    
    [self finishTimer];
    self.priTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(priOnLineComeOnTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.priTimer forMode:NSRunLoopCommonModes];
    
    //在线播放超时设置
    if (oTime>0) {
        
        [self finishTimeOutTimer];
        self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:oTime target:self selector:@selector(priTimerOutAction:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timeOutTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)pause
{
    [_audioPlayer pause];
    [_player pause];
    [self.priTimer pauseTimer];
}

-(void)resume
{
    [_audioPlayer play];
    [_player play];
    [self.priTimer resumeTimer];
}

- (void) priAddObserver
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self.addNotic addObserver:self selector:@selector(onLinePlayerOver:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.addNotic addObserver:self selector:@selector(onLinePlayerOver:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:_player.currentItem];
}

- (void) priRemoveObserver
{
    [self.addNotic removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.addNotic removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:_player.currentItem];
}


#pragma mark -- timerAction

- (void) priOnLineComeOnTimer:(NSTimer *) pTimer
{
    Float64 currTime = CMTimeGetSeconds(self.player.currentTime);
    Float64 duration = CMTimeGetSeconds(self.player.currentItem.asset.duration);
    
    NSError *pError = self.player.error;
    
    if (isnan(currTime)) {
        currTime = 0.0;
    }
    if (isnan(duration)) {
        duration = 0.0;
    }
    
    self.currentPlan = duration;
    
    progressBlock tempBlock = [self.mutBlock objectForKey:_bKeyString];
    
    
    if (!_finishPlay) {
        
        if (tempBlock) {
            tempBlock(currTime, duration, pError, NO, self);
        }
    }else{
        
        if (tempBlock) {
            tempBlock(currTime, duration, pError, YES, self);
        }
        
        [self finishTimer];
        [self finishTimeOutTimer];
        [self priRemoveObserver];
    }
}

- (void) priOffLineComeOnTimer:(NSTimer *) pTimer
{
    NSError *error = (NSError *)pTimer.userInfo;
    CGFloat duration = self.audioPlayer.duration;
    CGFloat currentTime = self.audioPlayer.currentTime;
    
    if (isnan(duration)) {
        duration = 0.0;
    }
    if (isnan(currentTime)) {
        currentTime = 0.0;
    }
    
    progressBlock tempBlock = [self.mutBlock objectForKey:_bKeyString];
    if (!self.finishPlay) {
        
        if (tempBlock) {
            tempBlock(currentTime, duration, error, NO, self);
        }
    } else {
        
        if (tempBlock) {
            tempBlock(currentTime, duration, error, YES, self);
        }
        
        [self finishTimer];
    }
}

- (void) priTimerOutAction:(NSTimer *) oTimer
{
    
    if (self.currentPlan>0) {
        // 有数据返回，不用timeOut
    }else{
        
        progressBlock tempBlock = [self.mutBlock objectForKey:_bKeyString];
        
        self.finishPlay = YES;
        
        if (tempBlock) {
            tempBlock(0, 0, [[NSError alloc] init], YES, self);
        }
        
        [self finishTimer];
        [self finishTimeOutTimer];
        [self priRemoveObserver];
        
        [self stop];
    }
}

#pragma mark -- tool

- (void) finishTimer
{
    if (self.priTimer) {
        [self.priTimer invalidate];
        self.priTimer = nil;
    }
}

- (void)finishTimeOutTimer
{
    if (self.timeOutTimer) {
        
        [self.timeOutTimer invalidate];
        self.timeOutTimer = nil;
    }
}

-(void)stop
{
    [self.mutBlock removeAllObjects];
    //移除监听，监听的任务是，播放原音时间
    [self priRemoveObserver];
    [self finishTimer];
    [self finishTimeOutTimer];
    
    _player = nil;
    
    [_audioPlayer stop];
    _audioPlayer = nil;
}

-(void)restart
{
    [_audioPlayer setCurrentTime:0];
    
    int32_t timeScale = _player.currentItem.asset.duration.timescale;
    [_player seekToTime:CMTimeMake(0.000000, timeScale)];
}

-(void)moveToSecond:(float) second {
    [_audioPlayer setCurrentTime:second];
    
    int32_t timeScale = _player.currentItem.asset.duration.timescale;
    [_player seekToTime:CMTimeMakeWithSeconds((Float64)second, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

-(void)moveToSection:(CGFloat)section {
    int audioPlayerSection = _audioPlayer.duration * section;
    [_audioPlayer setCurrentTime:audioPlayerSection];
    
    int32_t timeScale = _player.currentItem.asset.duration.timescale;
    Float64 playerSection = CMTimeGetSeconds(_player.currentItem.duration) * section;
    [_player seekToTime:CMTimeMakeWithSeconds(playerSection, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

-(void)changeSpeedToRate:(CGFloat)rate {
    _audioPlayer.rate = rate;
    _player.rate = rate;
}

-(void)changeVolumeToValue:(CGFloat)volume {
    _audioPlayer.volume = volume;
    _player.volume = volume;
}


#pragma mark -- AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.finishPlay = YES;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    self.finishPlay = YES;
}

@end

@implementation NSTimer (Control)

static NSString *const NSTimerPauseDate = @"NSTimerPauseDate";
static NSString *const NSTimerPreviousFireDate = @"NSTimerPreviousFireDate";

-(void)pauseTimer
{
    objc_setAssociatedObject(self, (__bridge const void *)(NSTimerPauseDate), [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)(NSTimerPreviousFireDate), self.fireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.fireDate = [NSDate distantFuture];
}

-(void)resumeTimer
{
    NSDate *pauseDate = objc_getAssociatedObject(self, (__bridge const void *)NSTimerPauseDate);
    NSDate *previousFireDate = objc_getAssociatedObject(self, (__bridge const void *)NSTimerPreviousFireDate);
    
    const NSTimeInterval pauseTime = -[pauseDate timeIntervalSinceNow];
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDate];
}


@end
