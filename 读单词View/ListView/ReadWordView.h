//
//  ReadWordView.h
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface ReadWordView : UIView

- (instancetype)initWithWordsModel:(NSArray<WordModel *> *)model;
- (instancetype)initWithWordsModel:(NSArray<WordModel *> *)model originalButtonClick:(void(^)(NSInteger index))originalClick recordButtonClick:(void(^)(NSInteger index))recordClick replayButtonClick:(void(^)(NSInteger index))replayClick;

- (void)refreshData;

@end
