//
//  pro.h
//  pro
//
//  Created by liyufeng on 14/12/12.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pro : NSObject

+ (NSDictionary *)propertiesNameAndTypeOfClass:(Class)class;
+ (NSString *)sqlStringCreatTable:(NSString *)tableName class:(Class)class;

@end
