//
//  FlyerPageViewController.swift
//  Easy Flyer
//
//  Created by 楊野勇智 on 2015/01/03.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class FlyerPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var categoryId : String?
    var currentViewIndex : Int = 0
    var flyers : Array<NSDictionary>?
    var selectedFlyer : NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if (self.categoryId != nil) {
            retrieveFlyers(self.categoryId!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveFlyers(category : String) {
        if self.categoryId == nil { return }
        
        let endpoint = NSUserDefaults.standardUserDefaults().valueForKey("endpoint") as String
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(endpoint + "/services/apexrest/Flyers.json", parameters: ["categoryid": self.categoryId!],
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                self.flyers = responseObject as? Array<NSDictionary>
                if self.flyers != nil && self.flyers!.count > 0 {
                    var content = self.storyboard!.instantiateViewControllerWithIdentifier("flyer_content") as FlyerContentViewController
                    content.flyer = self.flyers![0]
                    self.setViewControllers([content], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                    self.selectedFlyer = self.flyers![0]
                }
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                var alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let yesAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        )
    }
    
    func currentSelectedIndex() -> Int {
        if self.selectedFlyer == nil { return 0 }
        
        var count = 0
        for flyer in self.flyers! {
            if self.selectedFlyer! == flyer {
                break
            }
            count++
        }
        return count
    }
    
    func currentViewController() -> FlyerContentViewController? {
        if self.flyers == nil || self.flyers!.count == 0 { return nil}
        
        self.selectedFlyer = self.flyers![self.currentViewIndex]
        var content = self.storyboard!.instantiateViewControllerWithIdentifier("flyer_content") as FlyerContentViewController
        content.flyer = self.selectedFlyer
        
        return content
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if self.selectedFlyer == nil { return nil }
        
        self.currentViewIndex = self.currentSelectedIndex()
        if self.flyers!.count - 1 <= self.currentViewIndex {
            return nil
        } else {
            self.currentViewIndex++
        }
        
        return currentViewController()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if self.selectedFlyer == nil { return nil }
        
        self.currentViewIndex = self.currentSelectedIndex()
        if self.currentViewIndex <= 0 {
            return nil
        } else {
            self.currentViewIndex--
        }
        
        return currentViewController()
    }
    
}
