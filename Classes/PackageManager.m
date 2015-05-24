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

@property (nonatomic, strong) NSString * localManifestPath;

@property (nonatomic, strong) AFHTTPSessionManager * httpManager;
@property (nonatomic, strong) NSFileManager * fileManager;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) PackageManifest * localManifest;

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
    self.localManifestPath = [self.localContentPath stringByAppendingPathComponent:kFILE_MANIFEST];
  }
  return self;
}

- (void)validateLocalContent:(void(^ __nullable)(NSError* __nullable error, LocalContentStatus status))finished {
  __weak typeof(self) weakSelf = self;
  dispatch_async(self.queue, ^{
    __strong id sSelf = weakSelf;
    BOOL stage1 = [sSelf validateLocalContentFolderAndManifest];
    if (!stage1) {
      if (finished) {
        finished(nil, LocalContentStatusEmpty);
      }
    }
    BOOL stage2 = [sSelf validateLocalContentFiles];
    if (!stage2) {
      if (finished) {
        finished(nil, LocalContentStatusBroken);
      }
    }
  });
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
  BOOL hasFile = [self.fileManager fileExistsAtPath: self.localManifestPath
                                        isDirectory: &isDir];
  if (hasFile) {
    if (isDir) {
      [self.fileManager removeItemAtPath:self.localManifestPath error:nil];
      return NO;
    } else {
      self.localManifest = [PackageManifest manifestFromPath:self.localManifestPath];
      if (self.localManifest == nil) {
        [self.fileManager removeItemAtPath:self.localManifestPath error:nil];
      }
      return self.localManifest != nil;
    }
  } else {
    return NO;
  }
}

- (BOOL)validateLocalContentFiles {
  if (self.localManifest) {
    for (NSString* path in self.localManifest.files) {
      NSString * absolutePath = [self.localContentPath stringByAppendingPathComponent:path];
      BOOL isDir = NO;
      BOOL exists = [self.fileManager fileExistsAtPath: absolutePath
                                           isDirectory: &isDir];
      // return NO if any file's place is taken by a directory
      if (exists && isDir) {
        [self.fileManager removeItemAtPath:absolutePath error:nil];
        return NO;
      }
      // return NO if any file is missing
      if (!exists) {
        return NO;
      }
    }
    return YES;
  } else {
    return NO;
  }
}

@end
