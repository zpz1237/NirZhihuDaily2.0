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
    
    var webHeaderView: ParallaxHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 198))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "WebTopImage")
        
        webHeaderView = ParallaxHeaderView.parallaxHeaderViewWithSubView(imageView, forSize: CGSizeMake(self.view.frame.width, 198)) as! ParallaxHeaderView
        
        webHeaderView.delegate = self
        
        self.webView.scrollView.addSubview(webHeaderView)
        self.webView.scrollView.delegate = self
        
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/3892357").responseJSON { (_, _, dataResult) -> Void in
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
            
            //html = html.stringByReplacingOccurrencesOfString("<div class=\"img-place-holder\"></div>", withString: "")
            
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        webHeaderView.layoutWebHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    func lockDirection() {
        self.webView.scrollView.contentOffset.y = -154
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
