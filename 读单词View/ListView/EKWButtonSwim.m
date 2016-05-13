#import "EKWButtonSwim.h"
#import <QuartzCore/CALayer.h>

@interface CircleShapeLayer : CAShapeLayer

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progressWidth;

@end;


@implementation CircleShapeLayer


- (instancetype)init
{
    if ((self = [super init]))
    {
        [self setupLayer];
    }
    
    return self;
}

- (void)layoutSublayers
{
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    [super layoutSublayers];
}

- (void)setupLayer
{
    self.path = [self drawPathWithArcCenter];
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor clearColor].CGColor;
    self.lineWidth = 4;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor redColor].CGColor;
    self.progressLayer.lineWidth = 4;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:self.progressLayer];
    
}

- (CGPathRef)drawPathWithArcCenter
{
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:(-M_PI/2)
                                        endAngle:(3*M_PI/2)
                                       clockwise:YES].CGPath;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress<0.0f) {
        progress = 0.0f;
    }
    
    if (progress>1.0f) {
        progress = 1.0f;
    }
    _progress = progress;
    
    [UIView animateWithDuration:0 animations:^{
        
        self.progressLayer.strokeEnd = progress;
    }];
    
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    self.progressLayer.lineWidth = progressWidth;
    
    [self setNeedsDisplay];
}

@end


@interface EKWButtonSwim()

@property (nonatomic, strong) CircleShapeLayer *ppLayer;
@property (nonatomic, assign) CGPoint tempCenter;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation EKWButtonSwim


//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//
//    if (hitView == self){
//
//        return nil;
//    }
//    else{
//        return hitView;
//    }
//}

//托空间初始化
-(void)awakeFromNib
{
    [self setup];
}

//代码创建初始化
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    
    return  self;
}

-(void)setup
{
    self.tempCenter = self.center;
    
    self.ppLayer = [[CircleShapeLayer alloc] init];
    self.ppLayer.frame = self.bounds;
    self.ppLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.ppLayer];
    self.currentValue = 0.0;
    
    self.lineColor = [UIColor colorWithRed:183/255.0 green:1 blue:177/255.0 alpha:1];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.progress >= 0.1) {
        // 清零
        self.progress = 0.0f;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        __block CGFloat cProgress = 0.0;
        self.progress = cProgress;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(executeSimpleBlock:) userInfo:^{
            if (cProgress == 0.0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(beginAnimation)]) {
                    [self.delegate beginAnimation];
                }
            }
            cProgress += 0.1;
            CGFloat xxooProgress = cProgress / 10.0;
            if (xxooProgress <= 1) {
                self.progress = xxooProgress;
            } else {
                [self.timer invalidate];
                self.timer = nil;
                if (self.delegate && [self.delegate respondsToSelector:@selector(beginAnimation)]) {
                    [self.delegate endAnimation];
                }
            }
            
        } repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (void)executeSimpleBlock:(NSTimer *)inTimer {
    void (^block)() = (void (^)())[inTimer userInfo];
    if (block) {
        block();
    }
    
}
- (void)setProgressWidth:(CGFloat)progressWidth
{
    self.frame = CGRectMake(0, 0, progressWidth, progressWidth);
    self.center = self.tempCenter;
    
    self.ppLayer.frame = CGRectMake(0, 0, progressWidth, progressWidth);
    [self.ppLayer layoutSublayers];
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress <= 0.0) {
        
        self.ppLayer.hidden = YES;
        self.ppLayer.progress = 0.0;
    }else{
        
        self.ppLayer.hidden = NO;
        self.ppLayer.progress = progress;
    }
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    _currentValue = currentValue;
    
    if (_allValue<=0.0) {
        
        self.progress = 0.0;
    }else{
        
        CGFloat ratio = _currentValue/_allValue;
        self.progress = ratio;
    }
}

- (void)setAllValue:(CGFloat)allValue
{
    _allValue = allValue;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.ppLayer.progressColor = lineColor;
}

- (void)setBordWidth:(CGFloat)bordWidth
{
    _bordWidth = bordWidth;
    self.ppLayer.progressWidth = bordWidth;
}

@end
