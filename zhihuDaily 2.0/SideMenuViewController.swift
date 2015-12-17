//
//  SideMenuViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/12/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blurView: GradientView!
    var originState = true {
        didSet {
            if oldValue != originState {
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加最后一行的遮罩层
        blurView = GradientView(frame: CGRectMake(0, self.view.frame.height - 45 - 50, self.view.frame.width, 50), type: TRANSPARENT_ANOTHER_GRADIENT_TYPE)
        self.view.addSubview(blurView)
        
        //tableView以及父view的基础设置
        self.view.backgroundColor = UIColor(red: 19/255.0, green: 26/255.0, blue: 32/255.0, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 19/255.0, green: 26/255.0, blue: 32/255.0, alpha: 1)
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50.5
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    //更改StatusBar颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//tableViewDataSource和Delegate
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appCloud().themes.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("homeSideCell") as! HomeSideCell
            if originState == false {
                cell.contentView.backgroundColor = UIColor(red: 19/255.0, green: 26/255.0, blue: 32/255.0, alpha: 1)
                cell.homeImageView.tintColor = UIColor(red: 136/255.0, green: 141/255.0, blue: 145/255.0, alpha: 1)
                cell.homeTitleLabel.textColor = UIColor(red: 136/255.0, green: 141/255.0, blue: 145/255.0, alpha: 1)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("contentSideCell") as! ContentSideCell
        cell.contentTitleLabel.text = appCloud().themes[indexPath.row - 1].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //初始状态结束 回归正常UI搭配
        if let  _ = tableView.cellForRowAtIndexPath(indexPath) as? ContentSideCell {
            originState = false
        }
        //初始状态结束 回归正常UI搭配 且协助设置选中状态UI
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? HomeSideCell {
            originState = false
            cell.homeImageView.tintColor = UIColor.whiteColor()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //判定是否转场到主题日报文章列表
        if let nav = segue.destinationViewController as? UINavigationController {
            if let vc = nav.topViewController as? ThemeViewController {
                let index = self.tableView.indexPathForSelectedRow!.row
                vc.name = appCloud().themes[index - 1].name
                vc.id = appCloud().themes[index - 1].id
            }
        }
    }
}