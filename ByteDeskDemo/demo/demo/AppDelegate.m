//
//  AppDelegate.m
//  demo
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "AppDelegate.h"
#import <bytedesk-core/bdcore.h>

#import "BDApisTableViewController.h"
#import "KFKeFuApiViewController.h"
#import "KFIMApiViewController.h"

//#import "KFNavigationController.h"
#import "QDNavigationController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
    // [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [self initQMUI];
    
    // 修改导航背景色
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x007bff)];
    // 修改导航字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    // 界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //
    BDApisTableViewController *apisTableViewController = [[BDApisTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    QDNavigationController *aipNavigationController = [[QDNavigationController alloc] initWithRootViewController:apisTableViewController];
    self.window.rootViewController = aipNavigationController;
    [self.window makeKeyAndVisible];
    
    if ([BDSettings isAlreadyLogin]) {
        // 建立长连接
        [BDCoreApis connect];
        // 注册离线消息推送
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    // TODO: 增加网络检测，如果无网络则提示
    
    // TODO: 根据实际未读数目设置AppIcon数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //
    if ([BDSettings isAlreadyLogin]) {
        // 建立长连接
        [BDCoreApis connect];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 离线消息推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    // upload deviceToken: 4a89d8b0e971a3ff0ae6d1712ac62fa6bc1d6099756fa71b5d98d1708d12dfca
    DDLogInfo(@"deviceToken:%@", newToken);
    
    // TODO: 判断是否已经上传，无需重复上传；如果没有上传，则引导提示用户开启推送
    [BDCoreApis updateDeviceToken:newToken resultSuccess:^(NSDictionary *dict) {
        
    } resultFailed:^(NSError *error) {
        
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。%@", userInfo);
    /*
     {
     aps = {
         alert = {
             body = world;
             title = Hello;
         };
         badge = 5;
         "content-available" = 1;
         sound = default;
        };
     }
     */
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"注册推送失败，原因：%@",error);
}


#pragma mark - 初始化QMUI

-(void) initQMUI {
    
    QMUICMI.navBarHighlightedAlpha = 0.2f;                                      // NavBarHighlightedAlpha : QMUINavigationButton 在 highlighted 时的 alpha
    QMUICMI.navBarDisabledAlpha = 0.2f;                                         // NavBarDisabledAlpha : QMUINavigationButton 在 disabled 时的 alpha
    QMUICMI.navBarButtonFont = UIFontMake(17);                                  // NavBarButtonFont : QMUINavigationButtonTypeNormal 的字体（由于系统存在一些 bug，这个属性默认不对 UIBarButtonItem 生效）
    QMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                          // NavBarButtonFontBold : QMUINavigationButtonTypeBold 的字体
    //    QMUICMI.navBarBackgroundImage = UIImageMake(@"navigationbar_background");   // NavBarBackgroundImage : UINavigationBar 的背景图
    //    QMUICMI.navBarShadowImage = [UIImage new];                                  // NavBarShadowImage : UINavigationBar.shadowImage，也即导航栏底部那条分隔线
    QMUICMI.navBarBarTintColor = UIColorFromRGB(0x007bff);                      // NavBarBarTintColor : UINavigationBar.barTintColor，也即背景色
    QMUICMI.navBarTintColor = UIColorWhite;                                     // NavBarTintColor : QMUINavigationBar 的 tintColor，也即导航栏上面的按钮颜色
    QMUICMI.navBarTitleColor = NavBarTintColor;                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 QMUINavigationTitleView 的默认文字颜色
    QMUICMI.navBarTitleFont = UIFontBoldMake(17);                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 QMUINavigationTitleView 的默认字体
    //    QMUICMI.navBarLargeTitleColor = nil;                                        // NavBarLargeTitleColor : UINavigationBar 在大标题模式下的标题颜色，仅在 iOS 11 之后才有效
    //    QMUICMI.navBarLargeTitleFont = nil;                                         // NavBarLargeTitleFont : UINavigationBar 在大标题模式下的标题字体，仅在 iOS 11 之后才有效
    QMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;             // NavBarBarBackButtonTitlePositionAdjustment : 导航栏返回按钮的文字偏移
    QMUICMI.navBarBackIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];                                     // NavBarBackIndicatorImage : 导航栏的返回按钮的图片
    QMUICMI.navBarCloseButtonImage = [UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage : QMUINavigationButton 用到的 × 的按钮图片
    
    QMUICMI.navBarLoadingMarginRight = 3;                                       // NavBarLoadingMarginRight : QMUINavigationTitleView 里左边 loading 的右边距
    QMUICMI.navBarAccessoryViewMarginLeft = 5;                                  // NavBarAccessoryViewMarginLeft : QMUINavigationTitleView 里右边 accessoryView 的左边距
    QMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;// NavBarActivityIndicatorViewStyle : QMUINavigationTitleView 里左边 loading 的主题
    QMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [UIImage qmui_imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:UIColorWhite];     // NavBarAccessoryViewTypeDisclosureIndicatorImage : QMUINavigationTitleView 右边箭头的图片
    
    QMUICMI.statusbarStyleLightInitially = YES;                                 // StatusbarStyleLightInitially : 默认的状态栏内容是否使用白色，默认为 NO，也即黑色
    QMUICMI.needsBackBarButtonItemTitle = NO;                                   // NeedsBackBarButtonItemTitle : 全局是否需要返回按钮的 title，不需要则只显示一个返回image
}


#pragma mark - 截屏响应

- (void)userDidTakeScreenshot:(NSNotification *)notification {
    //
    DDLogInfo(@"检测到截屏");
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [self imageWithScreenshot];
    //添加显示
    UIImageView *imgvPhoto = [[UIImageView alloc]initWithImage:image_];
    imgvPhoto.frame = CGRectMake(self.window.frame.size.width/2, self.window.frame.size.height/2, self.window.frame.size.width/2, self.window.frame.size.height/2);
    //添加边框
    CALayer * layer = [imgvPhoto layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 5.0f;
    //添加四个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 10.0;
    //添加两个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 2.0;
    
    [self.window addSubview:imgvPhoto];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat {
    //
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot {
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

@end
