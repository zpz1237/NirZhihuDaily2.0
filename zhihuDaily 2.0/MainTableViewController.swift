//
//  MainTableViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/3/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import SDWebImage

class MainTableViewController: UITableViewController, SDCycleScrollViewDelegate, ParallaxHeaderViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var animator: ZFModalTransitionAnimator!
    var cycleScrollView: SDCycleScrollView!
    var loadCircleView: PNCircleChart!
    var loadingView: UIActivityIndicatorView!
    var dragging = false
    var triggered = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建leftBarButtonItem以及添加手势识别
        let leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        leftButton.tintColor = UIColor.whiteColor()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //配置无限循环scrollView
        cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.tableView.frame.width, 154), imageURLStringsGroup: nil)
        
        cycleScrollView.infiniteLoop = true
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView.autoScrollTimeInterval = 6.0;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycleScrollView.titleLabelTextFont = UIFont(name: "STHeitiSC-Medium", size: 21)
        cycleScrollView.titleLabelBackgroundColor = UIColor.clearColor()
        cycleScrollView.titleLabelHeight = 60
        
        //alpha在未设置的状态下默认为0
        cycleScrollView.titleLabelAlpha = 1
        
        //将其添加到ParallaxView
        let headerSubview: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithSubView(cycleScrollView, forSize: CGSizeMake(self.tableView.frame.width, 154)) as! ParallaxHeaderView
        headerSubview.delegate  = self
        
        //将ParallaxView设置为tableHeaderView
        self.tableView.tableHeaderView = headerSubview
        
        //如果不是第一次展示
        if appCloud().firstDisplay == false {
            updateData()
        }
        
        //如果是第一次启动
        if appCloud().firstDisplay {
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
                        self.navigationItem.setLeftBarButtonItem(leftButton, animated: false)
                        }, completion: { (finished) -> Void in
                            launchView.removeFromSuperview()
                    })
            }
            //展示完成后更改为false
            appCloud().firstDisplay = false
        } else {
            self.navigationItem.setLeftBarButtonItem(leftButton, animated: false)
        }
        
        //设置透明NavBar
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //tableView基础配置
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        //初始化下拉加载loadCircleView
        let comp1 = self.dateLabel.frame.width/2
        let comp2 = (self.dateLabel.text! as NSString).sizeWithAttributes(nil).width/2
        let loadCircleViewXPosition = comp1 - comp2 - 35
        
        loadCircleView = PNCircleChart(frame: CGRect(x: loadCircleViewXPosition, y: 3, width: 15, height: 15), total: 100, current: 0, clockwise: true, shadow: false, shadowColor: nil, displayCountingLabel: false, overrideLineWidth: 1)
        loadCircleView.backgroundColor = UIColor.clearColor()
        loadCircleView.strokeColor = UIColor.whiteColor()
        loadCircleView.strokeChart()
        loadCircleView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.dateLabel.addSubview(loadCircleView)
        
        //初始化下拉加载loadingView
        loadingView = UIActivityIndicatorView(frame: CGRect(x: loadCircleViewXPosition+2.5, y: 5.5, width: 10, height: 10))
        self.dateLabel.addSubview(loadingView)
        
        //收到广播
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateData", name: "todayDataGet", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Data
    //收到广播后刷新数据
    func updateData() {
        cycleScrollView.imageURLStringsGroup = [appCloud().topStory[0].image, appCloud().topStory[1].image, appCloud().topStory[2].image, appCloud().topStory[3].image, appCloud().topStory[4].image]
        cycleScrollView.titlesGroup = [appCloud().topStory[0].title, appCloud().topStory[1].title, appCloud().topStory[2].title, appCloud().topStory[3].title, appCloud().topStory[4].title]
        (self.cycleScrollView.subviews[0] as! UICollectionView).scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appCloud().contentStory.count + appCloud().pastContentStory.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //取得已读新闻数组以供配置
        let readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        if indexPath.row < appCloud().contentStory.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableContentViewCell") as! TableContentViewCell
            let data = appCloud().contentStory[indexPath.row]
            
            //验证是否已被点击过
            if let _ = readNewsIdArray.indexOf(data.id) {
                cell.titleLabel.textColor = UIColor.lightGrayColor()
            } else {
                cell.titleLabel.textColor = UIColor.blackColor()
            }
            
            cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
            cell.titleLabel.text = data.title
            
            return cell
        }
        
        let newIndex = indexPath.row - appCloud().contentStory.count
        
        guard appCloud().pastContentStory.count != 0 else {
            return UITableViewCell()
        }
        
        if appCloud().pastContentStory[newIndex] is DateHeaderModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableSeparatorViewCell") as! TableSeparatorViewCell
            let data = appCloud().pastContentStory[newIndex] as! DateHeaderModel
            
            cell.contentView.backgroundColor = UIColor(red: 1/255.0, green: 131/255.0, blue: 209/255.0, alpha: 1)
            cell.dateLabel.text = data.date
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableContentViewCell") as! TableContentViewCell
        let data = appCloud().pastContentStory[newIndex] as! ContentStoryModel
        
        //验证是否已被点击过
        if let _ = readNewsIdArray.indexOf(data.id) {
            cell.titleLabel.textColor = UIColor.lightGrayColor()
        } else {
            cell.titleLabel.textColor = UIColor.blackColor()
        }
        
        cell.imagesView.sd_setImageWithURL(NSURL(string: data.images[0]))
        cell.titleLabel.text = data.title
        
        return cell
    }
    
    //设置滑动极限修改该值需要一并更改layoutHeaderViewForScrollViewOffset中的对应值
    func lockDirection() {
        self.tableView.contentOffset.y = -154
    }
    
    //tableView点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //保证点击的是TableContentViewCell
        guard tableView.cellForRowAtIndexPath(indexPath) is TableContentViewCell else {
            return
        }
        
        //拿到webViewController
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.index = indexPath.row
        
        //找到对应newsID
        if indexPath.row < appCloud().contentStory.count {
            let id = appCloud().contentStory[indexPath.row].id
            webViewController.newsId = id
        } else {
            let newIndex = indexPath.row - appCloud().contentStory.count
            let id = (appCloud().pastContentStory[newIndex] as! ContentStoryModel).id
            webViewController.newsId = id
        }
        
        //取得已读新闻数组以供修改
        var readNewsIdArray = NSUserDefaults.standardUserDefaults().objectForKey(Keys.readNewsId) as! [String]
        
        //记录已被选中的id
        readNewsIdArray.append(webViewController.newsId)
        NSUserDefaults.standardUserDefaults().setObject(readNewsIdArray, forKey: Keys.readNewsId)
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        
        //实施转场
        self.presentViewController(webViewController, animated: true) { () -> Void in
            
        }
    }
    
    //collectionView点击事件
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        //拿到webViewController
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as!WebViewController
        webViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        //对animator进行初始化
        animator = ZFModalTransitionAnimator(modalViewController: webViewController)
        self.animator.dragable = true
        self.animator.bounces = false
        self.animator.behindViewAlpha = 0.7
        self.animator.behindViewScale = 0.9
        self.animator.transitionDuration = 0.7
        self.animator.direction = ZFModalTransitonDirection.Right
        
        //设置webViewController
        webViewController.transitioningDelegate = self.animator
        webViewController.newsId = appCloud().topStory[index].id
        webViewController.isTopStory = true
        
        //实施转场
        self.presentViewController(webViewController, animated: true) { () -> Void in
            
        }
    }
    
    // MARK: - ScrollViewDelegate
    //记录下拉状态
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
    }
    
    override func  scrollViewDidScroll(scrollView: UIScrollView) {
        //Parallax效果
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        //NavBar及titleLabel透明度渐变
        let color = UIColor(red: 1/255.0, green: 131/255.0, blue: 209/255.0, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        let prelude: CGFloat = 90
        
        if offsetY >= -64 {
            let alpha = min(1, (64 + offsetY) / (64 + prelude))
            //titleLabel透明度渐变
            (header.subviews[0].subviews[0] as! SDCycleScrollView).titleLabelAlpha = 1 - alpha
            (header.subviews[0].subviews[0].subviews[0] as! UICollectionView).reloadData()
            //NavBar透明度渐变
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            if loadCircleView.hidden != true {
                loadCircleView.hidden = true
            }
            if triggered == true && offsetY == -64 {
                triggered = false
            }
        } else {
            let ratio = (-offsetY - 64)*2
            if ratio <= 100 {
                if triggered == false && loadCircleView.hidden == true {
                    loadCircleView.hidden = false
                }
                loadCircleView.updateChartByCurrent(ratio)
            } else {
                if loadCircleView.current != 100 {
                    loadCircleView.updateChartByCurrent(100)
                }
                //第一次检测到松手
                if !dragging && !triggered {
                    loadCircleView.hidden = true
                    loadingView.startAnimating()
                    appCloud().requestAllNeededData({ () -> () in
                        self.loadingView.stopAnimating()
                    })
                    triggered = true
                }
            }
        }

        //依据contentOffsetY设置titleView的标题
        for separatorData in appCloud().offsetYValue {
            guard offsetY > separatorData.0 else {
                if dateLabel.text != separatorData.1 {
                    dateLabel.text = separatorData.1
                }
                break
            }
        }
        
    }
    
    // MARK: - Other
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //设置StatusBar为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

//拓展NavigationController以设置StatusBar
extension UINavigationController {
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
}
