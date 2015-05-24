//
//  PackageManager.h
//  AppPackageDemo
//
//  Created by Yanke Guo on 15/5/24.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LocalContentStatus) {
  LocalContentStatusNone,
  LocalContentStatusEmpty,
  LocalContentStatusBroken,
  LocalContentStatusExpired,
  LocalContentStatusOK
};

@interface PackageManager : NSObject

@property (nonatomic, strong, readonly) NSString * __nullable indexPagePath;

- (id __nonnull)initWithManifestUrl:(NSString* __nonnull)manifestUrl
                 preloadContentPath:(NSString* __nonnull)preloadContentPath
                   localContentPath:(NSString* __nonnull)localContentPath;

- (void)validateLocalContent:(void(^ __nullable)(NSError* __nullable error, LocalContentStatus status))finished;

- (void)extractPreloadContent:(void(^ __nullable)(NSError* __nullable error))finished;

- (void)syncLocalContent:(void(^ __nullable)(NSError* __nullable error))finished;

@end
