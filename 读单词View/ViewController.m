//
//  ViewController.m
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ViewController.h"
#import "ReadWordView.h"
#import "EKWAudioManager.h"
#import "ListView.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<WordModel *> *array;
//@property (nonatomic, strong) ReadWordView *readView;
@property (nonatomic, assign) int bbb;
@property (nonatomic, strong) ListView *listView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.listView];
    self.bbb = 10;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    ((WordModel*)self.array[2]).score = @"99";
//    [self.readView refreshData];
    
    [EKWAudioManager playOriginalSoundWithUrl:[NSURL URLWithString:@"123"] completion:^(BOOL finished) {
        NSLog(@"读完了");
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [EKWAudioManager playRecordSoundWithUrl:[NSURL URLWithString:@"333"] completion:^(BOOL finished) {
            NSLog(@"录音播放成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [EKWAudioManager recordingWithURL:[NSURL URLWithString:@"123"] completion:^(BOOL isSuccess) {
                    NSLog(@"%@", @"录音成功");
                }];
            });
        }];
    });
    
    
}
- (ListView *)listView {
    if (_listView == nil) {
        
        _listView = [[ListView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 400) model:self.array type:PlayModeAutomatic];
    }
    return _listView;
}
//- (ReadWordView *)readView {
//    if (_readView == nil) {
//
//        _readView = [[ReadWordView alloc] initWithWordsModel:self.array originalButtonClick:^(NSInteger index) {
//           
//            NSLog(@"originalButtonClick%ld", (long)index);
//        } recordButtonClick:^(NSInteger index) {
//            NSLog(@"recordButtonClick%ld", (long)index);
//        } replayButtonClick:^(NSInteger index) {
//            NSLog(@"replayButtonClick%ld", (long)index);
//        }];
//        _readView.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 400);
//    }
//    return _readView;
//}

- (NSArray *)array {
    if (_array == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            WordModel *model = [[WordModel alloc] initWithDictionary:array[i]];
            [arrayM addObject:model];
        }
        _array = [arrayM copy];
    }
    return _array;
}

@end
