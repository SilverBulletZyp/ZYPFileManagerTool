//
//  ViewController.m
//  ZYPFileManagerTool
//
//  Created by zhaoyunpeng on 16/12/16.
//  Copyright © 2016年 zhaoyunpeng. All rights reserved.
//

#import "ViewController.h"
#import "ZYPFileManager.h"

@interface ViewController ()
//@property (nonatomic, strong) NSTextField *filePathTitle;
@property (nonatomic, strong) NSTextField *filePathTF;
@property (nonatomic, strong) NSButton *openButton;
@property (nonatomic, strong) NSButton *scanButton;
@property (nonatomic, strong) NSButton *removeButton;

@property (nonatomic, strong) NSButton *getImageNameButton;
@property (nonatomic, strong) NSButton *getImagePathButton;
@property (nonatomic, strong) NSButton *unusedImageButton;
@property (nonatomic, strong) NSButton *removeUnusedImageButton;

@property (nonatomic, strong) ZYPFileManager *fileManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.filePathTitle = [[NSTextField alloc]initWithFrame:NSMakeRect(10, self.view.frame.size.height - 60 + (50-20)/2, 70, 20)];
//    [self.filePathTitle setBordered:NO];
//    [self.filePathTitle setEditable:NO];
//    [self.filePathTitle setEnabled:NO];
//    self.filePathTitle.stringValue = @"文件夹路径";
//    self.filePathTitle.alignment = NSTextAlignmentLeft;
//    self.filePathTitle.allowsEditingTextAttributes = NO;
//    self.filePathTitle.backgroundColor = [NSColor controlColor];
//    self.filePathTitle.textColor = [NSColor blackColor];
//    [self.view addSubview:self.filePathTitle];
    
    self.openButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, self.view.frame.size.height - 50 - (50-40)/2, 100, 40)];
    self.openButton.bezelStyle = NSRoundedBezelStyle;
    [self.openButton setTitle:@"打开文件夹"];
    [self.openButton setAction:@selector(onClickOpenButton:)];
    [self.view addSubview:self.openButton];
    
    
    self.filePathTF = [[NSTextField alloc]initWithFrame:NSMakeRect(CGRectGetMaxX(self.openButton.frame) + 15, self.view.frame.size.height - 60 + (50-20)/2, self.view.frame.size.width - 140 - CGRectGetMaxX(self.openButton.frame), 20)];
    self.filePathTF.placeholderString = @"文件夹路径";
    [self.filePathTF setEditable:NO];
    [self.view addSubview:self.filePathTF];
    
    self.scanButton = [[NSButton alloc]initWithFrame:NSMakeRect(self.view.frame.size.width - 110, self.view.frame.size.height - 50 - (50-40)/2, 100, 40)];
    self.scanButton.bezelStyle = NSRoundedBezelStyle;
    [self.scanButton setTitle:@"扫描文件夹"];
    [self.scanButton setAction:@selector(onClickScanButton:)];
    [self.view addSubview:self.scanButton];

    
    // 图片manager

    self.getImageNameButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, CGRectGetMinY(self.openButton.frame) - 60 - (50-40)/2, 100, 40)];
    self.getImageNameButton.bezelStyle = NSRoundedBezelStyle;
    [self.getImageNameButton setTitle:@"读取图片名"];
    [self.getImageNameButton setAction:@selector(onClickGetImageNameButton:)];
    [self.view addSubview:self.getImageNameButton];
    
    
    self.getImagePathButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, CGRectGetMinY(self.getImageNameButton.frame) - 30 - (50-40)/2, 100, 40)];
    self.getImagePathButton.bezelStyle = NSRoundedBezelStyle;
    [self.getImagePathButton setTitle:@"读取图片路径"];
    [self.getImagePathButton setAction:@selector(onClickGetImagePathButton:)];
    [self.view addSubview:self.getImagePathButton];
   
   
    self.unusedImageButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, CGRectGetMinY(self.getImagePathButton.frame) - 30 - (50-40)/2, 100, 40)];
    self.unusedImageButton.bezelStyle = NSRoundedBezelStyle;
    [self.unusedImageButton setTitle:@"读取未用图片"];
    [self.unusedImageButton setAction:@selector(onClickUnusedImageButton:)];
    [self.view addSubview:self.unusedImageButton];
    
   
    self.removeUnusedImageButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, CGRectGetMinY(self.unusedImageButton.frame) - 30 - (50-40)/2, 100, 40)];
    self.removeUnusedImageButton.bezelStyle = NSRoundedBezelStyle;
    [self.removeUnusedImageButton setTitle:@"清理未用图片"];
    [self.removeUnusedImageButton setAction:@selector(onClickRemoveUnusedImageButton:)];
    [self.view addSubview:self.removeUnusedImageButton];
    
    
    
    // other
    
    self.removeButton = [[NSButton alloc]initWithFrame:NSMakeRect(self.view.frame.size.width - 110, (50-40)/2, 100, 40)];
    self.removeButton.bezelStyle = NSRoundedBezelStyle;
    [self.removeButton setTitle:@"清空数据"];
    [self.removeButton setAction:@selector(onClickRemoveButton:)];
    [self.view addSubview:self.removeButton];
    
}

- (ZYPFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [[ZYPFileManager alloc]init];
    }
    return _fileManager;
}

// 打开文件夹
- (void)onClickOpenButton:(NSButton *)button {
    NSString *filePath = [self.fileManager getFilePath];
    if (filePath != nil) {
        self.filePathTF.stringValue = filePath;
    }
}
// 扫描文件夹
- (void)onClickScanButton:(NSButton *)button {
    if (self.fileManager.filePath != nil) {
        [self.fileManager scanAndGetFilePath:self.fileManager.filePath];
    }
}


- (void)onClickGetImageNameButton:(NSButton *)button {
    if (self.fileManager.fileArray != nil) {
        [self.fileManager getImageFileDetailWithType:FilePrintName];
    }
}

- (void)onClickGetImagePathButton:(NSButton *)button {
    if (self.fileManager.fileArray != nil) {
        [self.fileManager getImageFileDetailWithType:FilePrintPath];
    }
}

- (void)onClickUnusedImageButton:(NSButton *)button {
    if (self.fileManager.fileArray != nil) {
        [self.fileManager getUnusedImageFile];
    }
}

- (void)onClickRemoveUnusedImageButton:(NSButton *)button {
    
}

// 清空按钮
- (void)onClickRemoveButton:(NSButton *)button {
    self.filePathTF.stringValue = @"";
    [self.fileManager removeAllObject];
}






- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
