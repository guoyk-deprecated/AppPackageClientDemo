//
//  PackageManifest.m
//  AppPackageDemo
//
//  Created by Yanke Guo on 15/5/24.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//

#import "PackageManifest.h"

@implementation PackageManifest

+ (NSDate*)dateFromISO8601:(NSString*)string {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  return [dateFormatter dateFromString:string];
}

+ (instancetype)manifestFromPath:(NSString*)filePath {
  if (filePath == nil) { return nil; }
  return [self manifestFromData:[NSData dataWithContentsOfFile:filePath]];
}

+ (instancetype)manifestFromData:(NSData *)fileData {
  if (fileData == nil) { return nil; }
  return [self manifestFromDictionary:[NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil]];
}

+ (instancetype)manifestFromDictionary:(NSDictionary *)fileDictionary {
  if ([fileDictionary isKindOfClass:[NSDictionary class]]) { return nil; }
  return [[self alloc] initWithDictionary:fileDictionary];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
  if (self = [super init]) {
    self.version = dictionary[@"version"];
    self.main = dictionary[@"main"];
    self.platform = dictionary[@"platform"];
    self.downloadBaseUrl = dictionary[@"downloadBaseUrl"];
    NSString * nextCheckAtStr = dictionary[@"nextCheckAt"];
    if ([nextCheckAtStr isKindOfClass:[NSString class]]) {
      self.nextCheckAt = [PackageManifest dateFromISO8601:nextCheckAtStr];
    }
    self.platformFiles = dictionary[@"platformFiles"];
    self.files = dictionary[@"files"];
    
    if(![self validate]) {
      return nil;
    }
  }
  return self;
}

- (BOOL)validate {
  BOOL bood = YES;
  bood &= [self.version isKindOfClass:[NSString class]];
  bood &= [self.main isKindOfClass:[NSString class]];
  bood &= [self.downloadBaseUrl isKindOfClass:[NSString class]];
  bood &= [self.platform isKindOfClass:[NSDictionary class]];
  bood &= (self.platformFiles == nil || [self.platformFiles isKindOfClass:[NSDictionary class]]);
  bood &= (self.nextCheckAt == nil || [self.nextCheckAt isKindOfClass:[NSDate class]]);
  bood &= [self.files isKindOfClass:[NSArray class]];
  return bood;
}

@end
