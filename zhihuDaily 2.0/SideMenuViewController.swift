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
        self.tableView.rowHeight = 50
    }
    
    //获取总代理
    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
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
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("contentSideCell") as! ContentSideCell
        cell.contentTitleLabel.text = appCloud().themes[indexPath.row - 1].name
        return cell
    }
}