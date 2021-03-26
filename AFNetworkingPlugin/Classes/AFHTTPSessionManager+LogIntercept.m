//
//  AFHTTPSessionManager+LogIntercept.m
//  
//
//  Created by zluof on 2021/3/25.
//

#import "AFHTTPSessionManager+LogIntercept.h"
#import <objc/runtime.h>
@implementation AFHTTPSessionManager (LogIntercept)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(dataTaskWithHTTPMethod:URLString:parameters:headers:uploadProgress:downloadProgress:success:failure:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(intercept_dataTaskWithHTTPMethod:URLString:parameters:headers:uploadProgress:downloadProgress:success:failure:));
        if (!originalMethod || !swizzledMethod) return;
        class_addMethod([self class], method_getName(originalMethod),
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
        class_addMethod([self class], method_getName(swizzledMethod),
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (NSURLSessionDataTask *)intercept_dataTaskWithHTTPMethod:(NSString *)method
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                   headers:(NSDictionary<NSString *,NSString *> *)headers
                                            uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                          downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                                   success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                                   failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    return [self intercept_dataTaskWithHTTPMethod:method
                                        URLString:URLString
                                       parameters:parameters
                                          headers:headers
                                   uploadProgress:uploadProgress
                                 downloadProgress:downloadProgress
                                          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable object) {
#if DEBUG
        [self successResult:task object:object];
#endif
        success(task,object);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        [self failureResult:task error:error];
#endif
        failure(task,error);
    }];
    
    
}

- (NSDictionary *)responseInfo:(NSHTTPURLResponse *)response {
    NSMutableDictionary *dic = response.allHeaderFields.mutableCopy;
    dic[@"StatusCode"] = @(response.statusCode).stringValue;
    return dic.mutableCopy;
}

- (NSDictionary *)requestInfo:(NSURLRequest *)request {
    NSMutableDictionary *dic = request.allHTTPHeaderFields.mutableCopy;
    dic[@"URL"] = request.URL.absoluteString;
    dic[@"host"] = request.URL.host;
    return dic.mutableCopy;
}

- (void)successResult:(NSURLSessionDataTask *)task object:(id)object {
    NSMutableDictionary *responseInfo = [self responseInfo:
                                         (NSHTTPURLResponse *)task.response].mutableCopy;
    NSDictionary *requestInfo = [self requestInfo:task.currentRequest];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         requestInfo != nil ? requestInfo : @"null",@"request",
                         responseInfo != nil ? responseInfo : @"null",@"response",
                         object != nil ? object : @"null",@"body",nil];
    NSLog(@"%@",dic);
}

- (void)failureResult:(NSURLSessionDataTask *)task error:(NSError *)error {
    NSDictionary *jsonError = [NSDictionary new];
    if (error) {
        NSData *jsonData =
        [error userInfo][@"com.alamofire.serialization.response.error.data"];
        if (jsonData != nil) {
            NSError *err;
            jsonError = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingMutableContainers
                         error:&err];
        }else{
            jsonError = [error userInfo];
        }
    }
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    NSMutableDictionary *responseInfo = [[self responseInfo:responses]
                                         mutableCopy];
    NSDictionary *requestInfo = [self requestInfo:task.currentRequest];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         requestInfo != nil ? requestInfo : @"null",@"request",
                         responseInfo != nil ? responseInfo : @"null",@"response",
                         jsonError,@"error",nil];
    NSLog(@"%@",dic);
}
@end
