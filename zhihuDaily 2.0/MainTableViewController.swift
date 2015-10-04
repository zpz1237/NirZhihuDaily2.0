//
//  MainTableViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/3/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SDCycleScrollViewDelegate, ParallaxHeaderViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //生成第二启动页背景
        let launchView = UIView(frame: CGRectMake(0, -64, self.view.frame.width, self.view.frame.height))
        launchView.alpha = 0.99
        
        //得到第二启动页控制器并设置为子控制器
        let launchViewController = storyboard?.instantiateViewControllerWithIdentifier("launchViewController")
        self.addChildViewController(launchViewController!)
        
        //将第二启动页放到背景上
        launchView.addSubview(launchViewController!.view)
        
        //展示第二启动页并隐藏NavbarTitleView
        self.view.addSubview(launchView)
        self.navigationItem.titleView?.hidden = true
        
        //动画效果：第二启动页2.5s展示过后经0.2秒删除并恢复展示NavbarTitleView
        UIView.animateWithDuration(2.5, animations: { () -> Void in
            launchView.alpha = 1
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    launchView.alpha = 0
                    self.navigationItem.titleView?.hidden = false
                    }, completion: { (finished) -> Void in
                        launchView.removeFromSuperview()
                })
        }
        
        //设置透明NavBar
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //tableView基础配置
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.showsVerticalScrollIndicator = false
        
        //配置无限循环ScrollView
        let images = [appCloud().topStory[0].image, appCloud().topStory[1].image, appCloud().topStory[2].image, appCloud().topStory[3].image, appCloud().topStory[4].image].map { return UIImage(named: $0)! }
        
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.tableView.frame.width, 154), imagesGroup: images)
        
        cycleScrollView.infiniteLoop = true
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView.autoScrollTimeInterval = 6.0;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycleScrollView.titlesGroup = [appCloud().topStory[0].title, appCloud().topStory[1].title, appCloud().topStory[2].title, appCloud().topStory[3].title, appCloud().topStory[4].title]
        cycleScrollView.titleLabelTextFont = UIFont(name: "STHeitiSC-Medium", size: 21)
        cycleScrollView.titleLabelBackgroundColor = UIColor.clearColor()
        cycleScrollView.titleLabelHeight = 60

        //将其添加到ParallaxView
        let headerSubview: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithSubView(cycleScrollView, forSize: CGSizeMake(self.tableView.frame.width, 154)) as! ParallaxHeaderView
        headerSubview.delegate  = self
        
        //将ParallaxView设置为HeaderView
        self.tableView.tableHeaderView = headerSubview
        
    }

    //TableView数据源

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appCloud().contentStory.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 92
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableContentViewCell") as! TableContentViewCell
        
        let data = appCloud().contentStory[indexPath.row]
        
        cell.imagesView.image = UIImage(named: data.images[0])
        cell.titleLabel.text = data.title
        
        return cell
    }
    
    //TableView滑动到极限
    func lockDirection() {
        self.tableView.contentOffset.y = -154
    }
    
    //CollectionView点击事件
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        print(index)
    }
    
    //实现Parallax效果以及NavBar透明度渐变
    override func  scrollViewDidScroll(scrollView: UIScrollView) {
        
        let color = UIColor(red: 0/255.0, green: 139/255.0, blue: 255/255.0, alpha: 1)
        let offsetY = scrollView.contentOffset.y

        let prelude: CGFloat = 25
        
        if offsetY > prelude {
            let alpha = min(1, 1 - ((prelude + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
        
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    //设置statusBar为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

//拓展NavigationController以设置statusBar
extension UINavigationController {
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
}
