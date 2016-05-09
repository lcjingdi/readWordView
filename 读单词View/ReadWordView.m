//
//  ReadWordView.m
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ReadWordView.h"
#import "WordHeaderView.h"
#import "ReadWordCell.h"
#import "WordModel.h"

typedef void (^ButtonClickBlock)(NSInteger);

@interface ReadWordView()<UITableViewDelegate, UITableViewDataSource, WordHeaderViewDelegate, ReadWordCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<WordModel *> *modelsArray;
@property (nonatomic, weak) ButtonClickBlock originalClick;
@property (nonatomic, weak) ButtonClickBlock recordClick;
@property (nonatomic, weak) ButtonClickBlock replayClick;

@end

@implementation ReadWordView
{
    NSInteger _firstOpen;
    NSInteger _lastOpen;
}

- (instancetype)initWithWordsModel:(NSArray<WordModel *> *)model {
    _modelsArray = model;
    if (self = [super init]) {
        
        [self addSubview:self.tableView];
        
        [self headerViewDidClickHeaderView:0];
    }
    return self;
}
- (instancetype)initWithWordsModel:(NSArray<WordModel *> *)model originalButtonClick:(void (^)(NSInteger))originalClick recordButtonClick:(void (^)(NSInteger))recordClick replayButtonClick:(void (^)(NSInteger))replayClick {
    self.originalClick = originalClick;
    self.recordClick = recordClick;
    self.replayClick = replayClick;
    
    return [self initWithWordsModel:model];
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.modelsArray[section].isOpen) {
        return 1;
    } else {
        return 0;
    }
}
- (void)headerViewDidClickHeaderView:(NSInteger)selectedIndex {
    
    _firstOpen = -1;
    _lastOpen = -1;
    
    for (int i = 0; i < self.modelsArray.count; i++) {
        if (self.modelsArray[i].isOpen) {
            _firstOpen = i;
        }
    }
    
    _lastOpen = selectedIndex ;
    
    if (_firstOpen == _lastOpen || _firstOpen == -1) {
        _firstOpen = -1;
    } else {
        self.modelsArray[_firstOpen].open = NO;
    }

    //判断状态值
    if (self.modelsArray[_lastOpen].isOpen) {
//        //修改
        self.modelsArray[_lastOpen].open = NO;
    }else{
        self.modelsArray[_lastOpen].open = YES;
    }
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    if (_firstOpen != -1) {
        [set addIndex:_firstOpen];
    }
    [set addIndex:_lastOpen];
    
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    if (_firstOpen != -1) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:selectedIndex];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadWordCell *cell = [ReadWordCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.tag = indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    WordModel *model = self.modelsArray[section];
    NSLog(@"%@", model.text);
    CGSize size = [model.text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;

    NSLog(@"%@", NSStringFromCGSize(size));
        return size.height + 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WordHeaderView *view = [[WordHeaderView alloc] init];
    view.tag = section;
    view.model = self.modelsArray[section];
    view.delegate = self;
    return view;
}

- (void)refreshData {
    [self.tableView reloadData];
}
#pragma mark - ReadWordCellDelegate
- (void)originalButtonClick:(NSInteger)index {
    if (self.originalClick) {
        self.originalClick(index);
    }
}
- (void)recordButtonClick:(NSInteger)index {
    if (self.recordClick) {
        self.recordClick(index);
    }
}
- (void)replayButtonClick:(NSInteger)index {
    if (self.replayClick) {
        self.replayClick(index);
    }
}
@end
