//
//  WebViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/5/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class WebViewController: UIViewController, UIScrollViewDelegate, ParallaxHeaderViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusBarBackground: UIView!
    
    var webHeaderView: ParallaxHeaderView!
    var imageView: UIImageView!
    var orginalHeight: CGFloat = 0
    var titleLabel: myUILabel!
    var sourceLabel: UILabel!
    var blurView: GradientView!
    var refreshImageView: UIImageView!
    var dragging = false
    var triggered = false
    var newsId = ""
    var index = 1
    var isTopStory = false
    var hasImage = true
    var isThemeStory = false

    //滑到对应位置时调整StatusBar
    var statusBarFlag = true {
        didSet {
            UIView.animateWithDuration(0.2) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    //滑到对应位置时调整arrow方向
    var arrowState = false {
        didSet {
            if arrowState == true {
                
                guard index != 0 && isTopStory == false else {
                    return
                }
                
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            } else {
                
                guard index != 0 && isTopStory == false else {
                    return
                }
                
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //避免因含有navBar而对scrollInsets做自动调整
        self.automaticallyAdjustsScrollViewInsets = false
        
        //避免webScrollView的ContentView过长 挡住底层View
        self.view.clipsToBounds = true
        
        //隐藏默认返回button但保留左划返回
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.webView.delegate = self
        //对scrollView做基本配置
        self.webView.scrollView.delegate = self
        self.webView.scrollView.clipsToBounds = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(animated: Bool) {
        loadWebView(newsId)
    }
    
    //加载普通header
    func loadNormalHeader() {
        //载入上一篇Label
        let refreshLabel = UILabel(frame: CGRectMake(12, -45, self.view.frame.width, 45))
        refreshLabel.text = "载入上一篇"
        if index == 0 {
            refreshLabel.text = "已经是第一篇了"
            refreshLabel.frame = CGRectMake(0, -45, self.view.frame.width, 45)
        }
        refreshLabel.textAlignment = NSTextAlignment.Center
        refreshLabel.textColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        refreshLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        self.webView.scrollView.addSubview(refreshLabel)
        
        if refreshLabel.text != "已经是第一篇了" {
            //"载入上一篇"imageView
            refreshImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 47, -30, 15, 15))
            refreshImageView.contentMode = UIViewContentMode.ScaleAspectFill
            refreshImageView.image = UIImage(named: "arrow")?.imageWithRenderingMode(.AlwaysTemplate)
            refreshImageView.tintColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
            self.webView.scrollView.addSubview(refreshImageView)
        }
    }
    
    //加载图片
    func loadParallaxHeader(imageURL: String, imageSource: String, titleString: String) {
        
        //设置展示的imageView
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 223))
        imageView.contentMode = .ScaleAspectFill
        imageView.sd_setImageWithURL(NSURL(string: imageURL))
        
        //保存初始frame
        orginalHeight = imageView.frame.height
        
        //设置Image上的titleLabel
        titleLabel = myUILabel(frame: CGRectMake(15, orginalHeight - 80, self.view.frame.width - 30, 60))
        titleLabel.font = UIFont(name: "STHeitiSC-Medium", size: 21)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        titleLabel.verticalAlignment = VerticalAlignmentBottom
        titleLabel.numberOfLines = 0
        titleLabel.text = titleString
        imageView.addSubview(titleLabel)
        
        //设置Image上的Image_sourceLabel
        sourceLabel = UILabel(frame: CGRectMake(15, orginalHeight - 22, self.view.frame.width - 30, 15))
        sourceLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        sourceLabel.textColor = UIColor.lightTextColor()
        sourceLabel.textAlignment = NSTextAlignment.Right
        let sourceLabelText = imageSource
        sourceLabel.text = "图片：" + sourceLabelText
        imageView.addSubview(sourceLabel)
        
        //设置Image上的blurView
        blurView = GradientView(frame: CGRectMake(0, -85, self.view.frame.width, orginalHeight + 85), type: TRANSPARENT_GRADIENT_TWICE_TYPE)
        //在blurView上添加"载入上一篇"Label
        let refreshLabel = UILabel(frame: CGRectMake(12, 15, self.view.frame.width, 45))
        refreshLabel.text = "载入上一篇"
        if index == 0 || isTopStory {
            refreshLabel.text = "已经是第一篇了"
            refreshLabel.frame = CGRectMake(0, 15, self.view.frame.width, 45)
        }
        refreshLabel.textAlignment = NSTextAlignment.Center
        refreshLabel.textColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        refreshLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        blurView.addSubview(refreshLabel)
        
        if refreshLabel.text != "已经是第一篇了" {
            //在blurView上添加"载入上一篇"图片
            refreshImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 47, 30, 15, 15))
            refreshImageView.contentMode = UIViewContentMode.ScaleAspectFill
            refreshImageView.image = UIImage(named: "arrow")?.imageWithRenderingMode(.AlwaysTemplate)
            refreshImageView.tintColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
            blurView.addSubview(refreshImageView)
        }
        
        imageView.addSubview(blurView)
        //使Label不被遮挡
        imageView.bringSubviewToFront(titleLabel)
        imageView.bringSubviewToFront(sourceLabel)
        
        //将其添加到ParallaxView
        webHeaderView = ParallaxHeaderView.parallaxWebHeaderViewWithSubView(imageView, forSize: CGSizeMake(self.view.frame.width, 223)) as! ParallaxHeaderView
        webHeaderView.delegate = self
        
        //将ParallaxView添加到webView下层的scrollView上
        self.webView.scrollView.addSubview(webHeaderView)
    }

    //加载WebView
    func loadWebView(id: String) {
        //获取网络数据，包括body css image image_source title
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/" + id).responseJSON { (_, _, dataResult) -> Void in
            guard dataResult.error == nil else {
                print("获取数据失败")
                return
            }
            
            //若body存在 拼接body与css后加载
            if let body = JSON(dataResult.value!)["body"].string {
                let css = JSON(dataResult.value!)["css"][0].string!
                
                if let image = JSON(dataResult.value!)["image"].string {
                    if let titleString = JSON(dataResult.value!)["title"].string {
                        if let imageSource = JSON(dataResult.value!)["image_source"].string {
                            self.loadParallaxHeader(image, imageSource: imageSource, titleString: titleString)
                        } else {
                            self.loadParallaxHeader(image, imageSource: "(null)", titleString: titleString)
                        }
                        self.setNeedsStatusBarAppearanceUpdate()
                    }
                } else {
                    self.hasImage = false
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.statusBarBackground.backgroundColor = UIColor.whiteColor()
                    self.loadNormalHeader()
                }
                
                var html = "<html>"
                html += "<head>"
                html += "<link rel=\"stylesheet\" href="
                html += css
                html += "</head>"
                html += "<body>"
                html += body
                html += "</body>"
                html += "</html>"
                
                self.webView.loadHTMLString(html, baseURL: nil)
            } else {
                //若是直接使用share_url的类型
                self.hasImage = false
                self.setNeedsStatusBarAppearanceUpdate()
                self.statusBarBackground.backgroundColor = UIColor.whiteColor()
                self.loadNormalHeader()
                
                let url = JSON(dataResult.value!)["share_url"].string!
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
        
    }
    
    //实现Parallax效果
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //判断是否含图
        if hasImage {
            let incrementY = scrollView.contentOffset.y
            if incrementY < 0 {
                //不断设置titleLabel及sourceLabel以保证frame正确
                titleLabel.frame = CGRectMake(15, orginalHeight - 80 - incrementY, self.view.frame.width - 30, 60)
                sourceLabel.frame = CGRectMake(15, orginalHeight - 20 - incrementY, self.view.frame.width - 30, 15)
                
                //保证frame正确
                blurView.frame = CGRectMake(0, -85 - incrementY, self.view.frame.width, orginalHeight + 85)
                
                //如果下拉超过65pixels则改变图片方向
                if incrementY <= -65 {
                    arrowState = true
                    //如果此时是第一次检测到松手则加载上一篇
                    guard dragging || triggered else {
                        //index不能为零, 且不为topStory
                        if index != 0 && isTopStory == false {
                            loadNewArticle(true)
                            triggered = true
                        }
                        return
                    }
                } else {
                    arrowState = false
                }
                
                //使Label不被遮挡
                imageView.bringSubviewToFront(titleLabel)
                imageView.bringSubviewToFront(sourceLabel)
            }
            
            //监听contentOffsetY以改变StatusBarUI
            if incrementY > 223 {
                if statusBarFlag {
                    statusBarFlag = false
                    if var parent = self.parentViewController {
                        while (parent.parentViewController != nil) {
                            parent = parent.parentViewController!
                        }
                        (parent as! WebViewController).statusBarFlag = false
                    }
                }
                statusBarBackground.backgroundColor = UIColor.whiteColor()
            } else {
                guard statusBarFlag else {
                    statusBarFlag = true
                    if var parent = self.parentViewController {
                        while (parent.parentViewController != nil) {
                            parent = parent.parentViewController!
                        }
                        (parent as! WebViewController).statusBarFlag = true
                    }
                    return
                }
                statusBarBackground.backgroundColor = UIColor.clearColor()
            }
            
            webHeaderView.layoutWebHeaderViewForScrollViewOffset(scrollView.contentOffset)
        } else {
            //如果下拉超过40pixels则改变图片方向
            if self.webView.scrollView.contentOffset.y <= -40 {
                arrowState = true
                //如果此时是第一次检测到松手则加载上一篇
                guard dragging || triggered else {
                    //index不能为零, 且不为topStory
                    if index != 0 {
                        loadNewArticle(true)
                        triggered = true
                    }
                    return
                }
            } else {
                arrowState = false
            }
        }
    }
    
    //记录下拉状态
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
    //设置滑动极限 修改该值需要一并更改layoutWebHeaderViewForScrollViewOffset中的对应值
    func lockDirection() {
        self.webView.scrollView.contentOffset.y = -85
    }
    
    //加载新文章
    func loadNewArticle(previous: Bool) {
        //生成动画初始位置
        let offScreenUp = CGAffineTransformMakeTranslation(0, -self.view.frame.height)
        let offScreenDown = CGAffineTransformMakeTranslation(0, self.view.frame.height)
        
        //生成新View并传入新数据
        let toWebViewController = self.storyboard!.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController
        let toView = toWebViewController.view
        toView.frame = self.view.frame
        
        //数据相关
        if isThemeStory == false {
            //找到上一篇文章的newsID
            index--
            if index < appCloud().contentStory.count {
                let id = appCloud().contentStory[index].id
                toWebViewController.index = index
                toWebViewController.newsId = id
            } else {
                var newIndex = index - appCloud().contentStory.count
                
                //如果取到的不是文章则取上一篇
                if appCloud().pastContentStory[newIndex] is DateHeaderModel {
                    index--
                    newIndex--
                }
                
                //如果因上述情况newIndex = -1 则取contentStory中数据
                if newIndex > -1 {
                    let id = (appCloud().pastContentStory[newIndex] as! ContentStoryModel).id
                    toWebViewController.index = index
                    toWebViewController.newsId = id
                } else {
                    let id = appCloud().contentStory[index].id
                    toWebViewController.index = index
                    toWebViewController.newsId = id
                }
            }
        } else {
            index--
            let id = appCloud().themeContent!.stories[index].id
            toWebViewController.index = index
            toWebViewController.newsId = id
            toWebViewController.isThemeStory = true
        }
        
        //取得已读新闻数组以供修改
        var readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        //记录已被选中的id
        readNewsIdArray.append(toWebViewController.newsId)
        NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        
        //生成原View截图并添加到主View上
        let fromView = self.view.snapshotViewAfterScreenUpdates(true)
        self.view.addSubview(fromView)
        
        //将toView放置到屏幕之外并添加到主View上
        toView.transform = offScreenUp
        self.view.addSubview(toView)
        self.addChildViewController(toWebViewController)
        
        //动画开始
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //fromView下滑出屏幕，新View滑入屏幕
            fromView.transform = offScreenDown
            toView.transform = CGAffineTransformIdentity
            }, completion: { (success) -> Void in
                //动画完成后清理底层webView、statusBarBackground，以及滑出屏幕的fromView，这里也有问题，多次加载新文章会每次留一层UIView 待解决
                self.webView.removeFromSuperview()
                self.statusBarBackground.removeFromSuperview()
                fromView.removeFromSuperview()
        })
    }
    
    //依据statusBarFlag返回StatusBar颜色
     override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //无图的情况
        guard hasImage else {
            return .Default
        }
        if statusBarFlag {
            return .LightContent
        }
        return .Default
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension WebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //暂时的处理方法，只允许查看文章内容 而不允许将其当做浏览器跳转，待修改
//        guard webView.request != nil else {
//            return true
//        }
//        if request != webView.request {
//            return false
//        }
        return true
    }
}
