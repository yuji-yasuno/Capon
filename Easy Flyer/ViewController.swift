//
//  ViewController.swift
//  Easy Flyer
//
//  Created by 楊野勇智 on 2015/01/01.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RNFrostedSidebarDelegate {

    var categories = Array<NSDictionary>()
    var categoryImages = NSMutableDictionary()
    var setting = NSDictionary()
    @IBOutlet weak var topimgView: UIImageView!
    @IBOutlet weak var waitIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveFlyerSetting()
        retrieveFlyerCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveFlyerSetting() {
        
        let endpoint = NSUserDefaults.standardUserDefaults().valueForKey("endpoint") as String
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        let operation = manager.GET(endpoint + "/services/apexrest/FlyerSetting.json", parameters: nil,
            success: { (operation : AFHTTPRequestOperation!, responseObject : AnyObject!) in
                if responseObject !=  nil {
                    self.setting = responseObject as NSDictionary
                    var url : NSURL = NSURL(string: self.setting["TopPageImageUrl__c"]! as String)!
                    self.topimgView.setImageWithURL(url)
                }
        },
            failure: { (operation : AFHTTPRequestOperation!, error : NSError!) in
                var alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let yesAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func retrieveFlyerCategories() {
        
        let endpoint = NSUserDefaults.standardUserDefaults().valueForKey("endpoint") as String
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(endpoint + "/services/apexrest/FlyerCategories.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                self.categories = responseObject as Array<NSDictionary>
                
                self.categoryImages = NSMutableDictionary()
                for category : NSDictionary in self.categories {
                    let iconImageUrl = category["IconImageUrl__c"] as String
                    let imagedata = NSData(contentsOfURL: NSURL(string: iconImageUrl)!)
                    let image = UIImage(data: imagedata!)
                    let categoryId = category["Id"] as String
                    self.categoryImages.setValue(image, forKey: categoryId)
                }
                
                self.waitIndicatorView.stopAnimating()
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                var alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let yesAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                self.presentViewController(alert, animated: true, completion: nil)
                self.waitIndicatorView.stopAnimating()
            }
        )
    }
    
    func colorFromHex(hex: String) -> UIColor! {
        
        let scanner = NSScanner(string: hex)
        var hexColor : UInt32 = 0x0
        scanner.scanHexInt(&hexColor)
        
        let red = (hexColor & 0xFF0000) >> (4 * 4)
        let green = (hexColor & 0x00FF00) >> (4 * 2)
        let blue = (hexColor & 0x0000FF)
        let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(1))
        
        return color
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        if self.categories.isEmpty { return }
        
        var icons = Array<UIImage>()
        var colors = Array<UIColor>()
        for category : NSDictionary in self.categories {
            
            let image: UIImage = self.categoryImages[category["Id"]! as String] as UIImage
            icons.append(image as UIImage)
            
            let iconColor = category["IconColor__c"] as String
            colors.append(colorFromHex(iconColor))
        }
        var indeces = NSMutableIndexSet()
        var sidebar = RNFrostedSidebar(images: icons, selectedIndices: indeces, borderColors: colors)
        sidebar.isSingleSelect = true
        sidebar.delegate = self
        sidebar.show()
    }
    
    func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        let category = self.categories[Int(index)]
        var flyerpage = self.storyboard!.instantiateViewControllerWithIdentifier("flyer_page") as FlyerPageViewController
        flyerpage.categoryId = category["Id"] as? String
        self.presentViewController(flyerpage, animated: true, completion: nil)
    }

}

