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
    
    //滑到对应位置时调整StatusBar
    var statusBarFlag = true {
        didSet {
            UIView.animateWithDuration(0.2) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        blurView = GradientView(frame: CGRectMake(0, -30, self.view.frame.width, orginalHeight + 30), type: TRANSPARENT_GRADIENT_TWICE_TYPE)
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
            
            //不断添加删除blurView以保证frame正确
            blurView.removeFromSuperview()
            let tempBlurView = GradientView(frame: CGRectMake(0, -30, self.view.frame.width, orginalHeight + 30 - incrementY), type: TRANSPARENT_GRADIENT_TWICE_TYPE)
            imageView.addSubview(tempBlurView)
            blurView = tempBlurView
            
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
    
    //设置滑动极限 修改该值需要一并更改layoutWebHeaderViewForScrollViewOffset中的对应值
    func lockDirection() {
        self.webView.scrollView.contentOffset.y = -85
    }
    
    //依据statusBarFlag返回StatusBar颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if statusBarFlag {
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
