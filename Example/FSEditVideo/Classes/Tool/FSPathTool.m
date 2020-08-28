//
//  FSPathTool.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/14.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSPathTool.h"

@implementation FSPathTool

+ (void)load {
    [self clearFileFromAppStart];
}

+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - 路径
+ (NSString *)rootPath {
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return cacheFolder;
}

+ (NSString *)folderPathWithName:(NSString *)folder {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self rootPath],folder];
    if (folder == nil) {
        path = [self rootPath];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/// 获取文件路径，name：目录
+ (NSString *)videoRandomPathWithName:(NSString *)name {
    NSString *videoFolder = [self folderPathWithName:name];
    NSString *nowTimeStr = [FSPathTool createName];
    NSString *nameString = [NSString stringWithFormat:@"%@.mp4",nowTimeStr];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", videoFolder, nameString];
    return urlString;
}

+ (NSString *)folderVideoPathWithName:(NSString *)name fileName:(NSString *)fileName {
    NSString *videoFolder = [self folderPathWithName:name];
    NSString *nameString = fileName;
    if (nameString == nil) {
        NSString *nowTimeStr = [self createName];
        nameString = [NSString stringWithFormat:@"%@.mp4",nowTimeStr];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", videoFolder, nameString];
    return urlString;
}

+ (NSString *)createName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    return nowTimeStr;
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    // 如果覆盖，那么先删掉原文件
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [self deleteLocalPath:toPath];
        }
    }
    // 复制文件，如果不覆盖且文件已存在则会复制失败
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:nil];
    
    return isSuccess;
}

/// 启动时清除文件
+ (void)clearFileFromAppStart {
    [self clearFolders:@[DNRecordTmpFloder,DNRecordCompoundFolder]];
}

+ (void)clearFolders:(NSArray *)folders {
    if (folders) {
        DN_WEAK_SELF
        [folders enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DN_STRONG_SELF
            NSString *path = [self folderPathWithName:obj];
            [self deleteLocalPath:path];
        }];
    }
}

#pragma mark - 删除
+ (BOOL)deleteLocalURL:(NSURL *)URL {
    return [self deleteLocalPath:URL.path];
}

+ (BOOL)deleteLocalPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path];
    BOOL isDelete = NO;
    if (existed) {
        isDelete = [fileManager removeItemAtPath:path error:nil];
    }
    return isDelete;
}

@end
