//
//  GXFileTool.h
//  GXApp
//
//  Created by futang yang on 16/7/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GXUserdefult [NSUserDefaults standardUserDefaults]

@interface GXFileTool : NSObject


/// 根据文件名判断是否存在文件
+(BOOL)isExistFileName:(NSString *)fileName;
/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName;
/// 通过文件名从沙盒中找到归档的对象
+(id)readObjectByFileName:(NSString*)fileName;
/// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName;




/// 根据key名判断偏好设置里是否存在
+(BOOL)isExistKeyName:(NSString *)KeyName;
/// 把对象归档成NSData类型(对象需要是实现接档归档遵守NSCoding协议)
+ (NSData *)changeObjectToData:(id)objc;
/// 把NSData解档成对象
+ (id)changeDataToObject:(NSData *)data;

+(void)saveUserData:(id)data forKey:(NSString*)key;
/// 读取用户偏好设置
+(id)readUserDataForKey:(NSString*)key;
/// 删除用户偏好设置
+(void)removeUserDataForkey:(NSString*)key;






@end
