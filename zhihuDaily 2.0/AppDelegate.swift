//
//  AppDelegate.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/1/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var topStory: [TopStoryModel] = []
    var contentStory: [ContentStoryModel] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let launchViewController = mainStoryboard.instantiateViewControllerWithIdentifier("launchViewController")
//        self.window?.rootViewController = launchViewController
        
        //配置测试数据
        topStory.append(TopStoryModel(image: "TopImage1", id: "", title: "胳膊上中了一枪"))
        topStory.append(TopStoryModel(image: "TopImage2", id: "", title: "看看哪些镜头是超考验技术含量的，以后也好给电影打个公平的分"))
        topStory.append(TopStoryModel(image: "TopImage3", id: "", title: "我的恋爱对象是……打印机和羊驼"))
        topStory.append(TopStoryModel(image: "TopImage4", id: "", title: "大厨怎么都是男的？女大厨哪儿去了？"))
        topStory.append(TopStoryModel(image: "TopImage5", id: "", title: "喏，拿去，生蚝的正确打开方式"))
        
        contentStory.append(ContentStoryModel(images: ["ContentImage1"], id: "", title: "胳膊上中了一枪"))
        contentStory.append(ContentStoryModel(images: ["ContentImage2"], id: "", title: "哭的时候，为什么眼睛会变红？"))
        contentStory.append(ContentStoryModel(images: ["ContentImage3"], id: "", title: "光是看着都很累，这些铁路线实在太忙了"))
        contentStory.append(ContentStoryModel(images: ["ContentImage4"], id: "", title: "看看哪些镜头是超考验技术含量的，以后也好给电影打个公平的分"))
        contentStory.append(ContentStoryModel(images: ["ContentImage5"], id: "", title: "妈妈你骗我，这里一定不是博物馆"))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

