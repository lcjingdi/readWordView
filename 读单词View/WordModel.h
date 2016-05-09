//
//  WordModel.h
//  读单词View
//
//  Created by jingdi on 16/5/5.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordModel : NSObject
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *real_text;
@property (nonatomic, copy) NSString *record_duration;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, assign, getter=isOpen) BOOL open;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
