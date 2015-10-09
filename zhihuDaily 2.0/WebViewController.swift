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

class WebViewController: UIViewController, UIScrollViewDelegate, ParallaxHeaderViewDelegate {

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
    
    //为了解决statusBar的bug
    var hasChanged = false
    
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
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            } else {
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.refreshImageView.transform = CGAffineTransformIdentity
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //避免webScrollView的ContentView过长 挡住底层View
        self.view.clipsToBounds = true
        
        //设置展示的imageView
        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 223))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "WebTopImage")
       
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
        titleLabel.text = "青蒿素的研发方法，早有先例，也不会是最后一例"
        imageView.addSubview(titleLabel)
        
        //设置Image上的Image_sourceLabel
        sourceLabel = UILabel(frame: CGRectMake(15, orginalHeight - 22, self.view.frame.width - 30, 15))
        sourceLabel.font = UIFont(name: "HelveticaNeue", size: 9)
        sourceLabel.textColor = UIColor.lightTextColor()
        sourceLabel.textAlignment = NSTextAlignment.Right
        let sourceLabelText = "Ton Rulkens / CC BY"
        sourceLabel.text = "图片：" + sourceLabelText
        imageView.addSubview(sourceLabel)
        
        //设置Image上的blurView
        blurView = GradientView(frame: CGRectMake(0, -85, self.view.frame.width, orginalHeight + 85), type: TRANSPARENT_GRADIENT_TWICE_TYPE)
        //在blurView上添加"载入上一篇"Label
        let refreshLabel = UILabel(frame: CGRectMake(12, 15, self.view.frame.width, 45))
        refreshLabel.text = "载入上一篇"
        refreshLabel.textAlignment = NSTextAlignment.Center
        refreshLabel.textColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        refreshLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        blurView.addSubview(refreshLabel)
        //在blurView上添加"载入上一篇"图片
        refreshImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 47, 30, 15, 15))
        refreshImageView.contentMode = UIViewContentMode.ScaleAspectFill
        refreshImageView.image = UIImage(named: "arrow")?.imageWithRenderingMode(.AlwaysTemplate)
        refreshImageView.tintColor = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
        blurView.addSubview(refreshImageView)
        imageView.addSubview(blurView)
        
        //使Label不被遮挡
        imageView.bringSubviewToFront(titleLabel)
        imageView.bringSubviewToFront(sourceLabel)
        
        //将其添加到ParallaxView
        webHeaderView = ParallaxHeaderView.parallaxWebHeaderViewWithSubView(imageView, forSize: CGSizeMake(self.view.frame.width, 223)) as! ParallaxHeaderView
        webHeaderView.delegate = self
        
        //将ParallaxView添加到webView下层的scrollView上并对scrollView做基本配置
        self.webView.scrollView.addSubview(webHeaderView)
        self.webView.scrollView.delegate = self
        self.webView.scrollView.clipsToBounds = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        //获取网络数据，包括body css image image_source title 并拼接body与css后加载
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/7235309").responseJSON { (_, _, dataResult) -> Void in
            let body = JSON(dataResult.value!)["body"].string!
            let css = JSON(dataResult.value!)["css"][0].string!
            
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
        }
    }

    //实现Parallax效果
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let incrementY = scrollView.contentOffset.y
        if incrementY < 0 {
            
            //不断设置titleLabel及sourceLabel以保证frame正确
            titleLabel.frame = CGRectMake(15, orginalHeight - 80 - incrementY, self.view.frame.width - 30, 60)
            sourceLabel.frame = CGRectMake(15, orginalHeight - 20 - incrementY, self.view.frame.width - 30, 15)
            
            //不断添加删除blurView.layer.sublayers![0]以保证frame正确
            blurView.frame = CGRectMake(0, -85 - incrementY, self.view.frame.width, orginalHeight + 85)
            blurView.layer.sublayers![0].removeFromSuperlayer()
            blurView.insertTwiceTransparentGradient()

            //如果下拉超过65pixels则改变图片方向
            if incrementY <= -65 {
                arrowState = true
                //如果此时是第一次检测到松手则加载上一篇
                guard dragging || triggered else {
                    loadNewArticle(true)
                    triggered = true
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
            }
            statusBarBackground.backgroundColor = UIColor.whiteColor()
        } else {
            guard statusBarFlag else {
                statusBarFlag = true
                return
            }
            statusBarBackground.backgroundColor = UIColor.clearColor()
        }
        
        webHeaderView.layoutWebHeaderViewForScrollViewOffset(scrollView.contentOffset)
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
        hasChanged = true
        print(hasChanged)
        //生成动画初始位置
        let offScreenUp = CGAffineTransformMakeTranslation(0, -self.view.frame.height)
        let offScreenDown = CGAffineTransformMakeTranslation(0, self.view.frame.height)
        
        //生成新View并传入新数据
        let toWebViewController = self.storyboard!.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController
        let toView = toWebViewController.view
        toView.frame = self.view.frame
        
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
        print("status hasChanged",hasChanged)
        if statusBarFlag {
            //bug：当切换页面后statusBarFlag即便被设置为false，执行该函数时会却变成true.. 暂采取折中方法解决 待研究
            return .LightContent
        }
        return .Default
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
