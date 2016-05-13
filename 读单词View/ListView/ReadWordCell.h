//
//  ReadWordCell.h
//  读单词View
//
//  Created by jingdi on 16/5/5.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadWordCellDelegate <NSObject>

@optional
- (void)originalButtonClick:(NSInteger)index;
- (void)recordButtonClick:(NSInteger)index;
- (void)replayButtonClick:(NSInteger)index;

@end

@interface ReadWordCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<ReadWordCellDelegate> delegate;

@end
