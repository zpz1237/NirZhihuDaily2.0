//
//  LaunchViewController.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/1/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, JSAnimatedImagesViewDataSource {

    @IBOutlet weak var animatedImagesView: JSAnimatedImagesView!
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatedImagesView.dataSource = self
        
        //半透明遮罩层
        let blurView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        blurView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.21)
        animatedImagesView.addSubview(blurView)
        
        //渐变遮罩层
        let gradientView = GradientView(frame: CGRectMake(0, self.view.frame.height / 3 * 2, self.view.frame.width, self.view.frame.height / 3 ), type: TRANSPARENT_GRADIENT_TYPE)
        animatedImagesView.addSubview(gradientView)
        
        //遮罩层透明度渐变
        UIView.animateWithDuration(2.5) { () -> Void in
            blurView.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    func animatedImagesNumberOfImages(animatedImagesView: JSAnimatedImagesView!) -> UInt {
        return 2
    }
    
    func animatedImagesView(animatedImagesView: JSAnimatedImagesView!, imageAtIndex index: UInt) -> UIImage! {
        return UIImage(named: "DemoLaunchImage")
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
