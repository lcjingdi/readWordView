//
//  WordHeaderView.m
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "WordHeaderView.h"
#import "UIView+Extension.h"

@interface WordHeaderView()
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *scoreButton;
@end

@implementation WordHeaderView

//+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
//    static NSString *identifier = @"header";
//    
//    WordHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//    
//    if (view == nil) {
//        view = [[WordHeaderView alloc] initWithReuseIdentifier:identifier];
//    }
//    return view;
//}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.innerView];

    }
    return self;
}
- (void)btnOnClick:(UIButton *)button {
    NSLog(@"按钮被点击了");
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewDidClickHeaderView:)]) {
        [self.delegate headerViewDidClickHeaderView:self.tag];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.innerView.frame = self.bounds;
    self.headerButton.frame = self.innerView.bounds;
    
    self.label.frame = CGRectMake(20, 20, self.width - 80, 0);
    [self.label sizeToFit];

    self.scoreButton.frame = CGRectMake(self.width - 40, self.label.y, 30, 30);
    
}

- (void)setModel:(WordModel *)model {
    _model = model;
    
    self.label.text = model.text;
    if (model.score == nil || [model.score isEqualToString:@""]) {
        self.scoreButton.hidden = YES;
    } else {
        self.scoreButton.hidden = NO;
        [self.scoreButton setTitle:model.score forState:UIControlStateNormal];
    }
}

#pragma mark - lazy
- (UIView *)innerView {
    if (_innerView == nil) {
        UIView *view = [[UIView alloc] init];
        
        [view addSubview:self.headerButton];
        [view addSubview:self.label];
        [view addSubview:self.scoreButton];
        
        _innerView = view;
    }
    return _innerView;
}
- (UIButton *)headerButton {
    if (_headerButton == nil) {
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:btn];
        _headerButton = btn;
    }
    return _headerButton;
}
- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        
        _label = label;
    }
    return _label;
}
- (UIButton *)scoreButton {
    if (_scoreButton == nil) {
        
        UIButton *scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreButton.enabled = NO;
        scoreButton.size = CGSizeMake(30, 30);
        scoreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        scoreButton.backgroundColor = [UIColor colorWithRed:97/255.0 green:204/255.0 blue:1 alpha:1];
        scoreButton.layer.cornerRadius = 15;
        scoreButton.clipsToBounds = YES;
        _scoreButton = scoreButton;
    }
    return _scoreButton;
}
@end
