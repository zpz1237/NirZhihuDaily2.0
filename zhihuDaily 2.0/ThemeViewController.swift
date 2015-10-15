//
//  ThemeViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/15/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "ThemeImage")
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
        //self.navigationController?.navigationBar.addSubview(<#T##view: UIView##UIView#>)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
