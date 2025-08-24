//
//  ViewController.m
//  ObjCVerify
//
//  Created by guanren on 2025/8/18.
//

#import "ViewController.h"
#import <WYBasisKitSwift-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    WYBasisKitConfigObjC.defaultScreenPixels = [[WYScreenPixelsObjC alloc] initWithWidth:0 height:0];
    
//    WYScrollInfoOptionsObjC *option = [[WYScrollInfoOptionsObjC alloc] init];
//    option.contentView = self.view;
//    option.offset = @(100.0);
//    option.config = [WYActivityConfigObjC scroll];
//    [WYActivityObjC showScrollInfo:@"" option:option];
//    [WYActivityObjC showScrollInfo:@"123"];
    
//    [WYActivityObjC showInfo:@"123"];
//    [WYActivityObjC showInfo:@"1234" option:nil];
    
//    WYLoadingInfoOptionsObjC *loadingOptions = [[WYLoadingInfoOptionsObjC alloc] init];
//    loadingOptions.animation = WYActivityAnimationObjCGifOrApng;
//    loadingOptions.config = [WYActivityConfigObjC concise];
//    loadingOptions.config.animationSize = CGSizeMake(50, 50);
    
//    [WYActivityObjC showLoadingIn:self.view];
//    [WYActivityObjC showLoading:@"123" in:self.view];
//    [WYActivityObjC showLoadingIn:self.view option:loadingOptions];
//    [WYActivityObjC showLoading:@"加载中" in:self.view option:loadingOptions];
    
//    WYBiometricModeObjC style = [WYBiometricAuthorizationObjC checkBiometricObjc];
//    [WYBiometricAuthorizationObjC verifyBiometricsObjcWithLocalizedFallbackTitle:@"" localizedReason:@"" handler:^(BOOL isBackupHandler, BOOL isSuccess, NSString * _Nonnull error) {
//
//    }];
    
//    [WYCameraAuthorizationObjC authorizeCameraAccessWithShowAlert:YES handler:^(BOOL authorized) {
//
//    }];
    
//    [WYContactsAuthorizationObjC authorizeAddressBookAccessWithShowAlert:YES keysToFetch:nil handler:^(BOOL authorized, NSArray<CNContact *> * _Nullable userInfo) {
//
//    }];
    
//    [WYMicrophoneAuthorizationObjC authorizeMicrophoneAccessWithShowAlert:YES handler:^(BOOL authorized) {
//
//    }];
    
//    [WYPhotoAlbumsAuthorizationObjC authorizeAlbumAccessWithShowAlert:YES handler:^(BOOL authorized, BOOL limited) {
//
//    }];
    
//    [WYSpeechRecognitionAuthorizationObjC authorizeSpeechRecognitionWithShowAlert:YES handler:^(BOOL authorized) {
//
//    }];
    
    WYCodableObjC *codableObjC = [[WYCodableObjC alloc] init];
    [codableObjC useDefaultKeys];
    [codableObjC convertFromSnakeCase];
    [codableObjC customKeyMapping:^NSString * _Nonnull(NSArray<NSString *> * _Nonnull keyPath) {
        // 自定义键映射逻辑
        NSString *lastKey = keyPath.lastObject;
        // 示例：将所有键转换为大写
        return [lastKey uppercaseString];
    }];
    
    @try {
        NSError *error = nil;
        NSDictionary *dic = [WYCodableObjC stringToDictionary:@"" error:&error];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    NSError *error = nil;
    NSObject *obj = [codableObjC decode:@"" modelClass:NSObject.class error:&error];
    
    NSString *str = [codableObjC encode:[[NSObject alloc] init] convertType:NSString.class error:&error];
}


@end
