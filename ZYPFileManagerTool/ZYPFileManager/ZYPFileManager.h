//
//  ZYPFileManager.h
//  ZYPFileManagerTool
//
//  Created by zhaoyunpeng on 16/12/16.
//  Copyright © 2016年 zhaoyunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, FilePrintType) {
    FilePrintName    = 0,   // 文件名
    FilePrintPath    = 1,   // 文件路径
    FilePrintContent = 2    // 文件内容
};


@interface ZYPFileManager : NSObject
// 文件路径
@property (nonatomic, strong) NSString *filePath;               // 文件夹路径
@property (nonatomic, strong) NSMutableArray *fileArray;        // 所有文件
@property (nonatomic, strong) NSMutableArray *filePathArray;    // 所有文件路径
@property (nonatomic, strong) NSMutableArray *fileContentArray; // 所有文件内容
@property (nonatomic, strong) NSMutableArray *codeFileArray;    // 代码文件路径
@property (nonatomic, strong) NSMutableArray *imageFileArray;   // 图片文件

/**
 获取当前文件夹路径

 @return 当前文件夹路径
 */
- (NSString *)getFilePath;


/**
 扫描路径并获取文件

 @param path 文件夹路径
 */
- (void)scanAndGetFilePath:(NSString *)path;


/**
 获取图片信息

 @param type 打印类型
 */
- (void)getImageFileDetailWithType:(FilePrintType)type;


/**
 获取未使用的图片
 */
- (void)getUnusedImageFile;

/**
 清除数据
 */
- (void)removeAllObject;


@end
