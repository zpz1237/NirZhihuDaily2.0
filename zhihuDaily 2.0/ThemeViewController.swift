//
//  ThemeViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/15/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        let navImageView = UIImageView(frame: CGRectMake(-100, 0, 500, 64))
        navImageView.contentMode = UIViewContentMode.ScaleAspectFill
        navImageView.clipsToBounds = true
        let image = UIImage(named: "ThemeImage")!.applyBlurWithRadius(5, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        //.applyBlurWithRadius(5, tintColor: UIColor(white: 0.1, alpha: 0.2), saturationDeltaFactor: 1.0, maskImage: nil)
        navImageView.image = image
        
        let themeSubview = ParallaxHeaderView.parallaxThemeHeaderViewWithSubView(navImageView, forSize: CGSizeMake(self.view.frame.width, 64)) as! ParallaxHeaderView
        themeSubview.delegate = self
        
        self.tableView.tableHeaderView = themeSubview
        self.view.addSubview(tableView)
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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

extension ThemeViewController: UITableViewDelegate, ParallaxHeaderViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutThemeHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    func lockDirection() {
        self.tableView.contentOffset.y = -95
    }
}
