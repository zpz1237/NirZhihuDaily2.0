//
//  ViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/1/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.showsVerticalScrollIndicator = false
        
        //Tips: TableHeaderViewCell中CollectionView的dataSource在Storyboard中已设置为当前类
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableHeaderViewCell") as! TableHeaderViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableContentViewCell") as! TableContentViewCell
        
        let data = appCloud().contentStory[indexPath.row - 1]
        
        cell.imagesView.image = UIImage(named: data.images[0])
        cell.titleLabel.text = data.title
        cell.titleLabel.verticalAlignment = VerticalAlignmentBottom
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appCloud().contentStory.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3
        }
        return 90
    }

    func appCloud() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

