//
//  ZYGNetworking.m
//  ZYGNetworkingDemo
//
//  Created by ZhangYunguang on 16/5/4.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ZYGNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface ZYGNetworking ()

@end

@implementation ZYGNetworking
static NSDictionary *httpHeaders = nil;
static NSString *baseUrl = nil;
static const CGFloat timeOut = 30.0f;
static const BOOL isLog = YES;

+(void)updateBaseUrl:(NSString *)newBaseUrl{
    baseUrl = newBaseUrl;
}
+(NSString *)baseUrl{
    return baseUrl;
}
+(void)configHeader:(NSDictionary *)header{
    httpHeaders = header;
}
#pragma mark - get请求
+(NSURLSessionTask *)getDataWithUrl:(NSString *)url progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed{
    return [self getDataWithUrl:url param:nil progress:progress success:success failed:failed];
}
+(NSURLSessionTask *)getDataWithUrl:(NSString *)url param:(NSDictionary *)param progress:(DownloadProgress)progress success:(ResponseSuccessBlock)success failed:(ResponseFailedBlock)failed{
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionTask *task = [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            DLOG(@"数据转json出错: %@",error);
        }
        if (isLog) {
            [self logWithSuccess:response url:[self getFullUrlWith:url] param:param];
        }
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isLog) {
            [self logWithFailed:error url:[self getFullUrlWith:url] param:param];
        }
        if (failed) {
            failed(error);
        }
    }];
    return task;
}
#pragma mark - 请求URL全路径
+(NSString *)getFullUrlWith:(NSString *)path{
    if (path == nil || path.length == 0) {
        return @"";
    }
    if ([self baseUrl] == nil || [self baseUrl].length == 0) {
        return path;
    }
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
}
#pragma mark - 下载对象
+(AFHTTPSessionManager *)manager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPSessionManager *manager = nil;
    if ([self baseUrl] == nil) {
        manager = [AFHTTPSessionManager manager];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    }
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    if (httpHeaders.allKeys.count) {
        for (NSString *key in httpHeaders.allKeys) {
            [manager.requestSerializer setValue:httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"
                                                                              ]];
    manager.requestSerializer.timeoutInterval = timeOut;
    manager.operationQueue.maxConcurrentOperationCount = 4;
    return manager;
}
#pragma mark - 打印日志
+(void)logWithSuccess:(id)response url:(NSString *)url param:(NSDictionary *)param{
    DLOG(@"request success:  \nresponse-->>:   \n%@\nurl     ----->>:    %@\nparam  -->>:   %@\n",response,url,param);
}
+(void)logWithFailed:(NSError *)error url:(NSString *)url param:(NSDictionary *)param{
    DLOG(@"request failed: \nerror  -->>:   %@\nurl  -->>:   %@\nparam  -->>:   %@",error,url,param);
}
@end
