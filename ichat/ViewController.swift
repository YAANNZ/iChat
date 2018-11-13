//
//  ViewController.swift
//  ichat
//
//  Created by Inbasis on 2018/11/8.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = "http://123.56.98.99:2080/zpm-admin/api/login/dologin"
        let dic = ["loginName":"admin","password":"123456"]
        
        Alamofire.request(url, method: .get, parameters:dic, encoding: URLEncoding.default, headers:nil).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                case .success:
                    if let dic:NSDictionary = (response.result.value as? NSDictionary) {
                        print(dic)
                        let aurl = "http://123.56.98.99:2080/zpm-admin/app/detail"
                        let token: String = dic["result"] as! String
                        let headers:[String: String] = ["sid": token]
                        Alamofire.request(aurl, method: .get, parameters:nil, encoding: URLEncoding.default, headers:headers).responseJSON(completionHandler: { (response) in
                            
                            switch response.result {
                            case .success:
                                if let dic:NSDictionary = (response.result.value as? NSDictionary) {
                                    print(dic)
                                  
                                    
                                }
                            case .failure(let error):
                                print(error)
                            }
                        })
                      }
                case .failure(let error):
                    print(error)
            }
        })

    }


}

