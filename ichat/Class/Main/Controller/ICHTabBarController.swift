//
//  ICHTabBarController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/15.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit

class ICHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initRootVC()
    }
    
    func initRootVC() {
        let kClassKey = "rootVCClassString"
        let kTitleKey = "title"
        let kImgKey = "imageName"
        let kSelImgKey = "selectedImageName"
        
        let childItemsArray:NSArray = [
            [kClassKey : "ichat.ICHMessageViewController",
             kTitleKey  : "消息",
             kImgKey    : "home_tabUnsel",
             kSelImgKey : "home_tabSel"],
            
            [kClassKey : "ichat.ICHFriendsViewController",
             kTitleKey  : "好友",
             kImgKey    : "toDo_tabUnsel",
             kSelImgKey : "toDo_tabSel"],
            
            [kClassKey  : "ichat.ICHDiscoverViewController",
             kTitleKey  : "发现",
             kImgKey    : "addressbook_tabUnsel",
             kSelImgKey : "addressbook_tabSel"],
            
            [kClassKey : "ichat.ICHProfileViewController",
             kTitleKey  : "我的",
             kImgKey    : "mine_tabUnsel",
             kSelImgKey : "mine_tabSel"] ];
        
        for item in childItemsArray {
            let vcItem = item as! NSDictionary
            let vcClass = NSClassFromString(vcItem.object(forKey: kClassKey) as! String) as! UIViewController.Type
            let VC = vcClass.init()
            let navVC = ICHNavigationController.init(rootViewController: VC)
            VC.title = vcItem.object(forKey: kTitleKey) as? String
            navVC.tabBarItem.image = UIImage.init(named: vcItem.object(forKey: kImgKey) as! String)
            navVC.tabBarItem.selectedImage = UIImage.init(named: vcItem.object(forKey: kSelImgKey) as! String)
            //            navVC.navigationBar.barTintColor = rgbColor(r: 37, g: 37, b: 37)
            //            navVC.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor :UIColor.rgbColorFromHex(rgb: 0x3590ec)], for: UIControl.State.selected)
            navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor :UIColor.rgbColorFromHex(rgb: 0xaab7c5)], for: UIControl.State.normal)
            
            
            self.addChild(navVC)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
