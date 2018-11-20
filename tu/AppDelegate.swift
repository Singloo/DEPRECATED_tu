//
//  AppDelegate.swift
//  tu
//
//  Created by Rorschach on 16/10/18.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import SnapKit
import Material


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


//        window = UIWindow(frame: UIScreen.main.bounds)

        

    
        
    
        ShareSDK.registerApp("1e17e681332be", activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue,SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeQQ.rawValue], onImport: { (platform : SSDKPlatformType) in
            switch platform
            {
            case SSDKPlatformType.typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
            case SSDKPlatformType.typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            case SSDKPlatformType.typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
            default:
                break
            }
            
        }, onConfiguration: { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
            case SSDKPlatformType.typeSinaWeibo:
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "4081184042",
                                            appSecret : "3b2128fe5aba752b0676c25fd83837d7",
                                            redirectUri : "https://api.weibo.com/oauth2/default.html",
                                            authType : SSDKAuthTypeBoth)
                
            case SSDKPlatformType.typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: "wx68b561de5967c188", appSecret: "c16ce4dd78ce51edcfaa5c94e334f308")
                
            case SSDKPlatformType.typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: "1106179840",
                                     appKey : "JgTV6T5R19sByK1F",
                                     authType : SSDKAuthTypeWeb)
            default:
                break
            }
        }

        )
        
        
        AVOSCloud.setApplicationId("2lsTHbqp6t7HMljJFyhFGvMY-gzGzoHsz", clientKey: "uzypjlaPhh2hedqABjv2VT7k")
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

