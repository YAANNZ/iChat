//
//  ICHLoginViewController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/20.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit
import SVProgressHUD

class ICHLoginViewController: UIViewController {

    @IBOutlet var usernameTextField: ICHTextField!
    @IBOutlet var passwordTextField: ICHTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userLeftImageView = UIImageView.init(image: UIImage.init(named: "login_user"))
        userLeftImageView.contentMode = .center
        self.usernameTextField.leftView = userLeftImageView
        self.usernameTextField.leftViewMode = .always
        
        let passwordLeftView = UIImageView.init(image: UIImage.init(named: "login_password"))
        passwordLeftView.contentMode = .center
        self.passwordTextField.leftView = passwordLeftView
        self.passwordTextField.leftViewMode = .always
    }


    @IBAction func loginEvent(_ sender: UIButton) {
        // 使用 OOMProvider 进行网络请求
        OOMLoadingProvider.request(OOMApi.doLogin(username: self.usernameTextField.text!, password: self.passwordTextField.text!)) { result in
            if case let .success(response) = result {
                
                // 解析数据
                let responseDict: NSDictionary = try! response.mapJSON() as! NSDictionary
                print(responseDict)
                
                if (responseDict.object(forKey: "flag") as! NSNumber).stringValue == "0" {
                    UserDefaults.standard.set(responseDict.object(forKey: "result"), forKey: TokenString)
                    UIApplication.shared.keyWindow?.rootViewController = ICHTabBarController()
                    
                } else {
                    SVProgressHUD.setMinimumDismissTimeInterval(2)
                    SVProgressHUD.showError(withStatus: responseDict.object(forKey: "msg") as? String)
                }
                
            } else {
                SVProgressHUD.setMinimumDismissTimeInterval(2)
                SVProgressHUD.showError(withStatus: "网络异常")
            }
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
