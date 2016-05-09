//
//  ViewController.m
//  读单词View
//
//  Created by jingdi on 16/5/4.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ViewController.h"
#import "ReadWordView.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<WordModel *> *array;
@property (nonatomic, strong) ReadWordView *readView;
@property (nonatomic, assign) int bbb;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.readView];
    self.bbb = 10;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ((WordModel*)self.array[2]).score = @"99";
    [self.readView refreshData];
    
}

- (ReadWordView *)readView {
    if (_readView == nil) {

        _readView = [[ReadWordView alloc] initWithWordsModel:self.array originalButtonClick:^(NSInteger index) {
           
            NSLog(@"originalButtonClick%ld", (long)index);
        } recordButtonClick:^(NSInteger index) {
            NSLog(@"recordButtonClick%ld", (long)index);
        } replayButtonClick:^(NSInteger index) {
            NSLog(@"replayButtonClick%ld", (long)index);
        }];
        _readView.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 400);
    }
    return _readView;
}

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
