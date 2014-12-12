//
//  pro.m
//  pro
//
//  Created by liyufeng on 14/12/12.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "pro.h"
#import <objc/runtime.h>
#import "EXTRuntimeExtensions.h"

@implementation pro

+ (NSDictionary *)propertiesNameAndTypeOfClass:(Class)class{
    NSMutableDictionary*result = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        mtl_propertyAttributes * mtlProperty = mtl_copyPropertyAttributes(property);
        NSDictionary * propertyDic = nil;
        if (mtlProperty->objectClass) {
            propertyDic = @{
                            @"class":NSStringFromClass(mtlProperty->objectClass),
                            @"type":@(mtl_propertyContentTypeReference)
                            };
        }else{
            if (mtlProperty->type[0]!='#' && mtlProperty->type[0]!='{' && mtlProperty->type[0]!='@') {
                NSString * key = [NSString stringWithCString:mtlProperty->type encoding:NSUTF8StringEncoding];
                if ([[self encodeTypeDictionary].allKeys containsObject:key]) {
                    propertyDic = @{
                                    @"class":[self encodeTypeDictionary][key],
                                    @"type":@(mtl_propertyContentTypeBase)
                                    };
                }else{
                    NSLog(@"字典缺少类型:%@",key);
                }
            }
        }
        if(propertyDic){
            NSString * propertyName = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
            [result setObject:propertyDic forKeyedSubscript:propertyName];
        }
    }
    return result;
}

+ (NSDictionary *)encodeTypeDictionary{
    static NSDictionary * typeDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDic = @{
                    [NSString stringWithCString:@encode(char) encoding:NSUTF8StringEncoding]:@"char",
                    [NSString stringWithCString:@encode(int) encoding:NSUTF8StringEncoding]:@"int",
                    [NSString stringWithCString:@encode(short) encoding:NSUTF8StringEncoding]:@"short",
                    [NSString stringWithCString:@encode(long) encoding:NSUTF8StringEncoding]:@"long",
                    [NSString stringWithCString:@encode(long long) encoding:NSUTF8StringEncoding]:@"long long",
                    [NSString stringWithCString:@encode(unsigned char) encoding:NSUTF8StringEncoding]:@"unsigned char",
                    [NSString stringWithCString:@encode(unsigned int) encoding:NSUTF8StringEncoding]:@"unsigned int",
                    [NSString stringWithCString:@encode(unsigned short) encoding:NSUTF8StringEncoding]:@"unsigned short",
                    [NSString stringWithCString:@encode(unsigned long) encoding:NSUTF8StringEncoding]:@"unsigned long",
                    [NSString stringWithCString:@encode(unsigned long long) encoding:NSUTF8StringEncoding]:@"unsigned long long",
                    [NSString stringWithCString:@encode(float) encoding:NSUTF8StringEncoding]:@"float",
                    [NSString stringWithCString:@encode(double) encoding:NSUTF8StringEncoding]:@"double",
                    [NSString stringWithCString:@encode(bool) encoding:NSUTF8StringEncoding]:@"bool",
                    [NSString stringWithCString:@encode(BOOL) encoding:NSUTF8StringEncoding]:@"Bool"
                    };
    });
    return typeDic;
}

+ (NSDictionary *)sqlTypeDictionary{
    static NSDictionary * sqlTypeDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlTypeDictionary = @{
                              //baseType
                              @"char":@"char(1)",
                              @"int":@"integer",
                              @"short":@"smallint",
                              @"long":@"integer",
                              @"long long":@"integer",
                              @"unsigned char":@"integer",
                              @"unsigned int":@"integer",
                              @"unsigned short":@"integer",
                              @"unsigned long":@"integer",
                              @"unsigned long long":@"text",
                              @"float":@"float",
                              @"double":@"double",
                              @"bool":@"bool",
                              @"Bool":@"bool",
                              @"NSString":@"text"
                              };
    });
    return sqlTypeDictionary;
}

//create table if not exists AllItemTable (id integer primary key autoincrement,"
//                                         "newID integer,author TEXT(1024),source TEXT(1024),title TEXT(1024),subtitle TEXT(1024),"
//                                         "shorttitle TEXT(1024),summary TEXT(1024),imgurl TEXT(1024),publishedtime TEXT(1024),readtimes TEXT(1024),"
//                                         "columid TEXT(1024),tasktype integer,importSource TEXT(1024),openType integer,newsType integer)

+ (NSString *)sqlStringCreatTable:(NSString *)tableName class:(Class)class{
    NSMutableString * resultString = [NSMutableString stringWithFormat:@"create table if not exists %@ ",tableName];
    NSDictionary * dic = [pro propertiesNameAndTypeOfClass:class];
    NSDictionary * sqlDic = [pro sqlTypeDictionary];
    [resultString appendString:@"(id integer primary key autoincrement"];
    for (NSString * key in dic.allKeys) {
        NSDictionary * typeDic = dic[key];
        NSString * type = typeDic[@"class"];
        if ([sqlDic.allKeys containsObject:type]) {
            [resultString appendFormat:@",%@ %@",key,sqlDic[type]];
        }else{
            NSLog(@"类型不存在%@->%@:%@",class,key,type);
        }
    }
    [resultString appendString:@")"];
    return resultString;
}



@end
