//
//  WordHeaderView.h
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"
@class WordHeaderView;

@protocol WordHeaderViewDelegate <NSObject>

- (void)headerViewDidClickHeaderView:(NSInteger)selectedIndex;

@end

@interface WordHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<WordHeaderViewDelegate> delegate;

@property (nonatomic, strong) WordModel *model;
@end
