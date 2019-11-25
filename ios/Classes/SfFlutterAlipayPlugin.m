#import "SfFlutterAlipayPlugin.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation SfFlutterAlipayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sf_flutter_alipay"
                                     binaryMessenger:[registrar messenger]];
    SfFlutterAlipayPlugin* instance = [[SfFlutterAlipayPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([@"aliPay" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSString* orderInfo = dic[@"orderInfo"];
        NSString* formScheme = [self fetchUrlScheme];
        [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:formScheme callback:^(NSDictionary *resultDic) {
            if(resultDic != NULL){
                result(resultDic);
            } else {
                result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"resultDic is NULL" details:nil]);
            }
        }];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

-(NSString*)fetchUrlScheme{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray* types = [infoDic objectForKey:@"CFBundleURLTypes"];
    for(NSDictionary* dic in types){
        if([@"alipay" isEqualToString: [dic objectForKey:@"CFBundleURLName"]]){
            return [dic objectForKey:@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

@end
