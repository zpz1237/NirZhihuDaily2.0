//
//  AppDelegate.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/1/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var topStory: [TopStoryModel] = []
    var contentStory: [ContentStoryModel] = []
    var pastContentStory: [PastContentStoryItem] = []
    var offsetYValue: [(CGFloat, String)] = []
    var themes: [ThemeModel] = []
    var themeContent: ThemeContentModel?
    var firstDisplay = true
    
    let dataQueue = dispatch_queue_create("dataQueue", DISPATCH_QUEUE_SERIAL)
    let semaphore = dispatch_semaphore_create(1)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        dispatch_async(dataQueue) { () -> Void in
            for i in 0..<7 {
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
                self.requestData(dataOfDate: NSDate().dateByAddingTimeInterval(28800 - Double(i) * 86400)) {
                    dispatch_semaphore_signal(self.semaphore)
                }
            }
        }
        
        //获取主题列表
        getThemesData()
        
        //初始化已读新闻数组
        if NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) == nil {
            let readNewsIdArray: [String] = []
            NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        }
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

    // MARK: - 数据相关
    /**
     请求当日首页文章数据
     */
    func requestTodayData() {
        requestData(dataOfDate: NSDate().dateByAddingTimeInterval(28800), completionHandler: nil)
    }
    
    /**
     请求给定日期的首页文章数据
     
     - parameter date: 东八区区时
     - parameter completionHandler: 完成闭包
     */
    func requestData(dataOfDate date:NSDate, completionHandler:(()->())?) {
        
            if date.dayOfWeek() == NSDate().dateByAddingTimeInterval(28800).dayOfWeek() {
                Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/latest").responseJSON { (_, _, resultData) -> Void in
                    guard resultData.error == nil else {
                        print("数据获取失败")
                        return
                    }
                    let data = JSON(resultData.value!)
                    //取到本日文章列表数据
                    let topStoryData = data["top_stories"]
                    let contentStoryData = data["stories"]
                    
                    //注入topStory
                    for i in 0 ..< topStoryData.count {
                        self.topStory.append(TopStoryModel(image: topStoryData[i]["image"].string!, id: String(topStoryData[i]["id"]), title: topStoryData[i]["title"].string!))
                    }
                    //注入contentStory
                    for i in 0 ..< contentStoryData.count {
                        self.contentStory.append(ContentStoryModel(images: [contentStoryData[i]["images"][0].string!], id: String(contentStoryData[i]["id"]), title: contentStoryData[i]["title"].string!))
                    }
                    //设置offsetYValue
                    self.offsetYValue.append((120 + CGFloat(contentStoryData.count) * 93, "今日热闻"))
                    
                    //发出完成通知
                    NSNotificationCenter.defaultCenter().postNotificationName("todayDataGet", object: nil)
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            } else {
                let componentOfURL = self.getCalenderString(date.dateByAddingTimeInterval(86400).description)
                let calenderStringOfDate = self.getCalenderString(date.description)
                
                Alamofire.request(.GET, "http://news.at.zhihu.com/api/4/news/before/" + componentOfURL).responseJSON { (_, _, resultData) -> Void in
                    guard resultData.error == nil else {
                        print("数据获取失败")
                        return
                    }
                    let data = JSON(resultData.value!)
                    
                    //取得日期Cell数据
                    let tempDateString = self.getDetailString(calenderStringOfDate) + " " + date.dayOfWeek()
                    self.pastContentStory.append(DateHeaderModel(dateString: tempDateString))
                    
                    //取得文章列表数据
                    let contentStoryData = data["stories"]
                    
                    //注入pastContentStory
                    for i in 0 ..< contentStoryData.count {
                        self.pastContentStory.append(ContentStoryModel(images: [contentStoryData[i]["images"][0].string!], id: String(contentStoryData[i]["id"]), title: contentStoryData[i]["title"].string!))
                    }
                    
                    //设置offsetYValue
                    self.offsetYValue.append((self.offsetYValue.last!.0 + 30 + CGFloat(contentStoryData.count) * 93, tempDateString))
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("pastDataGet", object: nil)
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            }
        
    }
    
    /**
      取得主题日报列表
     */
    func getThemesData() {
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/themes").responseJSON { (_, _, dataResult) -> Void in
            guard dataResult.error == nil else {
                print("获取数据失败")
                return
            }
            
            let data = JSON(dataResult.value!)["others"]
            for i in 0 ..< data.count {
                self.themes.append(ThemeModel(id: String(data[i]["id"]), name: data[i]["name"].string!))
            }
            
        }
    }
    
    // MARK: - 日期相关
    func getCalenderString(dateString: String) -> String {
        var calenderString = ""
        for character in dateString.characters {
            if character == " " {
                break
            } else if character != "-" {
                calenderString += "\(character)"
            }
        }
        return calenderString
    }
    
    func getDetailString(dateString: String) -> String {
        //拿到month
        var month = ""
        month = dateString.substringWithRange(Range(start: dateString.startIndex.advancedBy(4), end: dateString.startIndex.advancedBy(6)))
        if month.hasPrefix("0") {
            month.removeAtIndex(month.startIndex)
        }
        //拿到day
        var day = ""
        day = dateString.substringWithRange(Range(start: dateString.startIndex.advancedBy(6), end: dateString.startIndex.advancedBy(8)))
        if day.hasPrefix("0") {
            day.removeAtIndex(day.startIndex)
        }
        //拼接返回
        return month + "月" + day + "日"
    }
}

extension NSDate {
    func dayOfWeek() -> String {
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        let intValue = (days - 3) % 7
        switch intValue {
        case 0:
            return "星期日"
        case 1:
            return "星期一"
        case 2:
            return "星期二"
        case 3:
            return "星期三"
        case 4:
            return "星期四"
        case 5:
            return "星期五"
        case 6:
            return "星期六"
        default:
            break
        }
        return "未取到数据"
    }
}

