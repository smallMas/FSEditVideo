//
//  FSPathTool.h
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/14.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DNRecordTmpFloder @"FS_Record_Tmp"
#define DNRecordCompoundFolder @"FS_Video_Compound"
#define DNREcordEndFolder @"FS_Video_End"

NS_ASSUME_NONNULL_BEGIN

@interface FSPathTool : NSObject

/// 创建/获取Document下的目录
+ (NSString *)folderPathWithName:(NSString *)name;

/// 获取文件路径，name：目录
+ (NSString *)videoRandomPathWithName:(NSString *)name;

/// 目录下的文件
/// @param name 目录名字
/// @param fileName 文件名字 (可为空)
+ (NSString *)folderVideoPathWithName:(NSString *)name fileName:(NSString * __nullable)fileName;

/// 名字
+ (NSString *)createName;

/// 拷贝
/// @param path 被拷贝的路径
/// @param toPath 拷贝的最终路径
/// @param overwrite 是否覆盖
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;

/// 启动时清除文件
+ (void)clearFileFromAppStart;

#pragma mark - 删除
/// 删除本地路径
+ (BOOL)deleteLocalURL:(NSURL *)URL;
+ (BOOL)deleteLocalPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
