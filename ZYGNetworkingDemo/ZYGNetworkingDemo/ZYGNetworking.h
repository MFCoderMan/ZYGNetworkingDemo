//
//  ZYGNetworking.h
//  ZYGNetworkingDemo
//
//  Created by ZhangYunguang on 16/5/4.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLOG(FORMAT, ...) fprintf(stderr,"%s: %d\t  %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define NSLog(...)  NSLog(__VA_ARGS__)
#else
#define DLOG(...)
#define NSLog(...)
#endif

typedef void(^ResponseSuccessBlock)(id response);
typedef void(^ResponseFailedBlock)(NSError *error);
typedef void(^DownloadProgress)(int64_t downloadedData,
                                int64_t totalData);
@interface ZYGNetworking : NSObject

+ (NSString *)baseUrl;
+ (void)updateBaseUrl:(NSString *)newBaseUrl;
+ (void)configHeader:(NSDictionary *)header;
+ (NSURLSessionTask *)getDataWithUrl:(NSString *)url progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed;
+ (NSURLSessionTask *)getDataWithUrl:(NSString *)url param:(NSDictionary *)param progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed;
+ (NSURLSessionTask *)postDataWithUrl:(NSString *)url progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed;
+ (NSURLSessionTask *)postDataWithUrl:(NSString *)url param:(NSDictionary *)param progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed;

@end
