//
//  ZYPFileManager.m
//  ZYPFileManagerTool
//
//  Created by zhaoyunpeng on 16/12/16.
//  Copyright © 2016年 zhaoyunpeng. All rights reserved.
//

#import "ZYPFileManager.h"

@interface ZYPFileManager ()

@end

@implementation ZYPFileManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.filePath = [[NSString alloc]init];
        self.fileArray = [[NSMutableArray alloc]init];
        self.filePathArray = [[NSMutableArray alloc]init];
        self.fileContentArray = [[NSMutableArray alloc]init];
        self.codeFileArray = [[NSMutableArray alloc]init];
        self.imageFileArray = [[NSMutableArray alloc]init];
    }
    return self;
}

// 获取当前文件夹路径
- (NSString *)getFilePath {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = NO;
    
    if (openPanel.runModal == NSModalResponseOK) {
        NSString *dirPath = openPanel.directoryURL.path;
        if (dirPath != nil) {
            self.filePath = dirPath;
            return self.filePath;
        }
        return nil;
    }
    return nil;
}

// 扫描路径并获取文件
- (void)scanAndGetFilePath:(NSString *)path {
    
    if (path != nil) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self scanFilePath:path fileArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"扫描完成！");
                //            NSLog(@"文件内容 = \n%@",self.fileArray);
            });
        });
    }
}

- (void)scanFilePath:(NSString *)path fileArray:(NSMutableArray *)array {
    NSArray *tempArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    
    if (tempArray != nil) {
        for (NSString *file in tempArray) {
            
            // 当前文件路径
            NSString *pathName = [NSString stringWithFormat:@"%@/%@",path,file];
            
            BOOL isDirectory;
            BOOL exist = [[NSFileManager defaultManager]fileExistsAtPath:pathName isDirectory:&isDirectory];
            
            if (exist == YES && isDirectory == YES) {
                [self.fileArray addObject:file];
                [self.filePathArray addObject:pathName];
                [self getCodeFilePathArrayWithName:file path:pathName];
                [self scanFilePath:pathName fileArray:array];
            }
            else {
                [self.fileArray addObject:file];
                [self.filePathArray addObject:pathName];
                [self getCodeFilePathArrayWithName:file path:pathName];
            }
        }
    }
}

// 读取代码文件路径数组
- (void)getCodeFilePathArrayWithName:(NSString *)name path:(NSString *)path {
    
    if (![name isEqualToString:@".DS_Store"]) {
        
        if ([name hasSuffix:@".m"] || [name hasSuffix:@".swift"] || [name hasSuffix:@".xib"] || [name hasSuffix:@".storyboard"]) {
            NSLog(@"读取代码文件路径数组 = %@",name);
            [self.codeFileArray addObject:path];
        }
    }
}

// 读取图片名
- (void)getImageFileDetailWithType:(FilePrintType)type {
    
    if (self.fileArray != nil && self.filePathArray != nil) {
        
        if (type == FilePrintName) {
            for (NSString *string in self.fileArray) {
                if ([string containsString:@".png"]||[string containsString:@".jpg"]||
                    [string containsString:@".jpeg"]||[string containsString:@".gif"]) {
                    
                    [self.imageFileArray addObject:string];
                    [self readAndPrint:string type:type];
                }
            }
        }
        
        if (type == FilePrintPath) {
            for (NSString *string in self.filePathArray) {
                if ([string containsString:@".png"]||[string containsString:@".jpg"]||
                    [string containsString:@".jpeg"]||[string containsString:@".gif"]) {
                    
                    [self readAndPrint:string type:type];
                }
            }
        }
    }
}

// 获取未使用的图片
- (void)getUnusedImageFile {
    
    NSLog(@"图片数组 = %@",self.imageFileArray);
    __weak typeof (self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSString *imageFile in weakSelf.imageFileArray) {
            
            for (NSString *codeFilePath in weakSelf.codeFileArray) {
                NSURL *url = [NSURL fileURLWithPath:codeFilePath];
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
                NSString *fileContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                if (fileContent != nil) {
                    if (![fileContent containsString:imageFile]) {
                        NSLog(@"未使用的图片 = %@",imageFile);
                    }
                }
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"扫描完成！");
        });
    });
}



#pragma mark - 存储管理

- (void)removeAllObject {
    self.filePath = [[NSString alloc]init];
    self.fileArray = [[NSMutableArray alloc]init];
    self.filePathArray = [[NSMutableArray alloc]init];
    self.fileContentArray = [[NSMutableArray alloc]init];
    self.codeFileArray = [[NSMutableArray alloc]init];
    self.imageFileArray = [[NSMutableArray alloc]init];
}


#pragma mark - 打印机

// 读取和打印
- (void)readAndPrint:(NSString *)string type:(FilePrintType)type {
    if (type == FilePrintName) {
        [self readFileName:string];
    }
    if (type == FilePrintPath) {
        [self readFilePath:string];
    }
    if (type == FilePrintContent) {
        [self readFileContentWithPath:string];
    }
}

// 读取文件名
- (void)readFileName:(NSString *)fileName {
//    NSLog(@"%@",fileName);
}

// 读取文件路径
- (void)readFilePath:(NSString *)filePath {
//    NSLog(@"%@",filePath);
}

// 读取文件内容
- (void)readFileContentWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:nil];
    NSString *fileContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",fileContent);
}



@end
