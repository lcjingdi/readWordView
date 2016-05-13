//
//  ListView.m
//  读单词View
//
//  Created by jingdi on 16/5/13.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ListView.h"
#import "ReadWordView.h"
#import "WordModel.h"

@interface ListView()

@property (nonatomic, assign) PlayMode modeType;
@property (nonatomic, strong) WordModel *model;
@property (nonatomic, strong) ReadWordView *textView;
@property (nonatomic, strong) NSArray<WordModel *> *modelArray;
@end

@implementation ListView
- (instancetype)initWithFrame:(CGRect)frame model:(NSArray<WordModel *> *)model type:(PlayMode)type {
    if (self = [super initWithFrame:frame]) {
        
        self.modelArray = model;
        self.modeType = type;
        
        [self addSubview:self.textView];
    }
    return self;
}

- (ReadWordView *)textView {
    if (_textView == nil) {
        
        _textView = [[ReadWordView alloc] initWithWordsModel:self.modelArray originalButtonClick:^(NSInteger index) {
            NSLog(@"originalButtonClick%ld", (long)index);
        } recordButtonClick:^(NSInteger index) {
            NSLog(@"recordButtonClick%ld", (long)index);
        } replayButtonClick:^(NSInteger index) {
            NSLog(@"replayButtonClick%ld", (long)index);
        }];
        _textView.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 400);
    }
    return _textView;
}

@end
