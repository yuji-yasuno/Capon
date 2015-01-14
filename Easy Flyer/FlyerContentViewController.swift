//
//  FlyerContentViewController.swift
//  Easy Flyer
//
//  Created by 楊野勇智 on 2015/01/03.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class FlyerContentViewController: UIViewController, UIActionSheetDelegate {
    
    var flyer : NSDictionary?
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.flyer != nil {
            showImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showImage() {
        let imageUrl : String? = flyer!["ImageUrl__c"] as? String
        if imageUrl == nil { return }
        self.imgView.setImageWithURL(NSURL(string: imageUrl!))
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            break
        case 1:
            var nextVc : CouponRequestViewController = self.storyboard!.instantiateViewControllerWithIdentifier("coupon_request") as CouponRequestViewController
            if self.flyer != nil && self.flyer!["Id"] != nil {
                nextVc.flyerId = self.flyer!["Id"] as? String
            }
            self.presentViewController(nextVc, animated: true, completion: nil)
        case 2:
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }

    @IBAction func showAction(sender: AnyObject) {
        var actionSheet : UIActionSheet = UIActionSheet()
        actionSheet.title = "Action"
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Coupon")
        actionSheet.addButtonWithTitle("Close Page")
        actionSheet.cancelButtonIndex = 0
        actionSheet.showInView(self.view)
    }
}
