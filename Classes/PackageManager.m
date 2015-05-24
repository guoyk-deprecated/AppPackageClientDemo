//
//  PackageManager.m
//  AppPackageDemo
//
//  Created by Yanke Guo on 15/5/24.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//

#import "PackageManager.h"
#import <AFNetworking/AFNetworking.h>

#define kFILE_MANIFEST @"manifest.json"

@interface PackageManager()

@property (nonatomic, strong) NSString * manifestUrl;
@property (nonatomic, strong) NSString * preloadContentPath;
@property (nonatomic, strong) NSString * localContentPath;
@property (nonatomic, strong) AFHTTPSessionManager * httpManager;
@property (nonatomic, strong) NSFileManager * fileManager;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation PackageManager

- (id)initWithManifestUrl:(NSString *)manifestUrl
       preloadContentPath:(NSString*)preloadContentPath
         localContentPath:(NSString *)localContentPath {
  NSParameterAssert(manifestUrl);
  NSParameterAssert(preloadContentPath);
  NSParameterAssert(localContentPath);
  if (self = [super init]) {
    self.manifestUrl = manifestUrl;
    self.preloadContentPath = preloadContentPath;
    self.localContentPath = localContentPath;
    self.httpManager = [AFHTTPSessionManager manager];
    self.fileManager = [NSFileManager new];
    self.queue = dispatch_queue_create("io.yanke.package_manager", DISPATCH_QUEUE_SERIAL);
    _manifestUrl = [self.localContentPath stringByAppendingPathComponent:kFILE_MANIFEST];
  }
  return self;
}

- (void)validateLocalContent:(void(^ __nullable)(NSError* __nullable error, LocalContentStatus status))finished {
  __weak typeof(self) weakSelf = self;
}

- (void)extractPreloadContent:(void(^ __nullable)(NSError* __nullable error))finished {
}

- (void)syncLocalContent:(void(^ __nullable)(NSError* __nullable error))finished {
}

#pragma mark - Operations

- (void)ensureLocalContentFolder {
  BOOL isDir   = NO;
  BOOL hasFile = [self.fileManager fileExistsAtPath:self.localContentPath isDirectory:&isDir];
  if (hasFile && !isDir) {
    [self.fileManager removeItemAtPath:self.localContentPath error:nil];
  }
  [self.fileManager createDirectoryAtPath:self.localContentPath
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
}

- (BOOL)validateLocalContentFolderAndManifest {
  [self ensureLocalContentFolder];
  BOOL isDir   = NO;
  BOOL hasFile = [self.fileManager fileExistsAtPath: self.manifestUrl
                                        isDirectory: &isDir];
  if (hasFile) {
    if (isDir) {
      [self.fileManager removeItemAtPath:self.manifestUrl error:nil];
      return NO;
    }
    return YES;
  } else {
    return NO;
  }
}

@end
