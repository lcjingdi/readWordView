//
//  WordModel.m
//  读单词View
//
//  Created by jingdi on 16/5/5.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
