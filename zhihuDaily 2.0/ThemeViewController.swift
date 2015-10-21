//
//  ThemeViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/15/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var animator: ZFModalTransitionAnimator!
    var selectedNewsId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建leftBarButtonItem
        let leftButton = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        leftButton.tintColor = UIColor.whiteColor()
        self.navigationItem.setLeftBarButtonItem(leftButton, animated: false)
        
        //为当前view添加手势识别
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //生成并配置HeaderImageView
        let navImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 64))
        navImageView.contentMode = UIViewContentMode.ScaleAspectFill
        navImageView.clipsToBounds = true
        let image = UIImage(named: "ThemeImage")!
        navImageView.image = image
        
        //将其添加到ParallaxView
        let themeSubview = ParallaxHeaderView.parallaxThemeHeaderViewWithSubView(navImageView, forSize: CGSizeMake(self.view.frame.width, 64), andImage: image) as! ParallaxHeaderView
        themeSubview.delegate = self
        
        //将ParallaxView设置为tableHeaderView，主View添加tableView
        self.tableView.tableHeaderView = themeSubview
        self.view.addSubview(tableView)
        
        //设置NavigationBar为透明
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //tableView基础设置
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
    }

    override func viewWillAppear(animated: Bool) {
//        let rect = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
//        self.tableView.frame = rect
    }

    //设置StatusBar颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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

extension ThemeViewController: UITableViewDelegate, UITableViewDataSource, ParallaxHeaderViewDelegate {
    //实现Parallax效果
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutThemeHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    //设置滑动极限
    func lockDirection() {
        self.tableView.contentOffset.y = -95
    }
    
    //处理UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appCloud().themeContent!.stories.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("themeEditorTableViewCell") as! ThemeEditorTableViewCell
            for (index, editorsAvatar) in appCloud().themeContent!.editorsAvatars.enumerate() {
                let avatar = UIImageView(frame: CGRectMake(62 + CGFloat(37 * index), 12.5, 20, 20))
                avatar.contentMode = .ScaleAspectFill
                avatar.layer.cornerRadius = 10
                avatar.clipsToBounds = true
                avatar.image = UIImage(named: editorsAvatar)
                cell.contentView.addSubview(avatar)
            }
            return cell
        }
        
        //取到Story数据
        let tempContentStoryItem = appCloud().themeContent!.stories[indexPath.row - 1]
        
        //保证图片一定存在，选择合适的Cell类型
        guard let image = UIImage(named: tempContentStoryItem.images[0]) else {
            let cell = tableView.dequeueReusableCellWithIdentifier("themeTextTableViewCell") as! ThemeTextTableViewCell
            cell.themeTextLabel.text = tempContentStoryItem.title
            return cell
        }

        //处理图片存在的情况
        let cell = tableView.dequeueReusableCellWithIdentifier("themeContentTableViewCell") as! ThemeContentTableViewCell
        cell.themeContentLabel.text = tempContentStoryItem.title
        cell.themeContentImageView.image = image

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }
        return 92
    }
    
    //处理UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //拿到webViewController
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.7
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        webViewController.newsId = "Jst Try"
        
        //实施转场
        self.presentViewController(webViewController, animated: true) { () -> Void in
            
        }
    }
}
