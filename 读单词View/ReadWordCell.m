//
//  ReadWordCell.m
//  读单词View
//
//  Created by jingdi on 16/5/5.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ReadWordCell.h"

@interface ReadWordCell()

@end

@implementation ReadWordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ReadWordCell";
    ReadWordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReadWordCell" owner:self options:nil]lastObject];

    }
    return cell;
}
- (IBAction)originalButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(originalButtonClick:)]) {
        [self.delegate originalButtonClick:self.tag];
    }
}

- (IBAction)recordButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonClick:)]) {
        [self.delegate recordButtonClick:self.tag];
    }
}

- (IBAction)replayButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replayButtonClick:)]) {
        [self.delegate replayButtonClick:self.tag];
    }
}
@end
