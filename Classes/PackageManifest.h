//
//  PackageManifest.h
//  AppPackageDemo
//
//  Created by Yanke Guo on 15/5/24.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageManifest : NSObject

@property (nonatomic, strong) NSString        * version;
@property (nonatomic, strong) NSString        * main;
@property (nonatomic, strong) NSDictionary    * platform;
@property (nonatomic, strong) NSDate          * nextCheckAt;
@property (nonatomic, strong) NSString        * downloadBaseUrl;
@property (nonatomic, strong) NSDictionary    * platformFiles;
@property (nonatomic, strong) NSArray         * files;

+ (instancetype)manifestFromPath:(NSString*)filePath;

+ (instancetype)manifestFromData:(NSData*)fileData;

+ (instancetype)manifestFromDictionary:(NSDictionary*)fileDictionary;

@end
