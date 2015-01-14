//
//  CouponRequestViewController.swift
//  Easy Flyer
//
//  Created by 楊野勇智 on 2015/01/04.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class CouponRequestViewController: UIViewController {

    var flyerId : String?
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().stringForKey("user_email") != nil {
            self.email.text = NSUserDefaults.standardUserDefaults().stringForKey("user_email")! as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func requestCoupon(sender: AnyObject) {
        
        let emailpattern = "[\\w\\d_-]+@[\\w\\d_-]+\\.[\\w\\d._-]+"
        var error : NSError?
        var regularExp = NSRegularExpression(pattern: emailpattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)!
        let matches = regularExp.matchesInString(self.email.text, options: NSMatchingOptions.allZeros, range: NSRange(location: 0, length: countElements(self.email.text)))
        
        if matches.count == 0 {
            var alert = UIAlertController(title: "Caution", message: "Please input your email correctly", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        NSUserDefaults.standardUserDefaults().setValue(self.email.text, forKey: "user_email")
        
        let endpoint = NSUserDefaults.standardUserDefaults().valueForKey("endpoint") as String
        var manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer = AFJSONRequestSerializer()
        manager.requestSerializer = serializer
        let params = [ "flyerid" : self.flyerId!, "email" : self.email.text]
        manager.POST(endpoint + "/services/apexrest/FlyerCoupon",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                self.dismissViewControllerAnimated(true, completion: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                var alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.ActionSheet)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            })
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
