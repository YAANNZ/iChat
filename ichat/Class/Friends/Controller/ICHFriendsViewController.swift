//
//  ICHFriendsViewController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/18.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit
import SVProgressHUD

class ICHFriendsViewController: UIViewController {

    private let ICHFriendsTableViewCellIdentity = "ICHFriendsTableViewCellIdentity"
    
    var friendsArray: NSArray! = []
    var sectionTitleAry: NSArray! = ["A", "B"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
        let cellNib = UINib.init(nibName: "ICHFriendsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: ICHFriendsTableViewCellIdentity)
        
        OOMLoadingProvider.request(OOMApi.getFriendsList()) { result in
            if case let .success(response) = result {
                
                // 解析数据
                let responseDict: NSDictionary = try! response.mapJSON() as! NSDictionary
                print(responseDict)
                
                if (responseDict.object(forKey: "flag") as! NSNumber).stringValue == "0" {
                    let dataAry: NSArray = responseDict.object(forKey: "result") as! NSArray
                    self.friendsArray = [ContactModel].deserialize(from: dataAry)! as NSArray
                    //profilePhoto
                    self.tableView.reloadData()
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

}

extension ICHFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.text = self.sectionTitleAry[section] as? String
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ICHFriendsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: ICHFriendsTableViewCellIdentity, for: indexPath) as! ICHFriendsTableViewCell
        let contactModel: ContactModel = self.friendsArray[indexPath.row] as! ContactModel
        cell.nameLabel.text = contactModel.userName
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitleAry as? [String]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chatVC = ICHChatViewController()
        chatVC.contactModel = self.friendsArray[indexPath.row] as? ContactModel
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
