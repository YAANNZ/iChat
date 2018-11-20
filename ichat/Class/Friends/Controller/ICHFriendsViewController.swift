//
//  ICHFriendsViewController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/18.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit

class ICHFriendsViewController: UIViewController {

    private let ICHFriendsTableViewCellIdentity = "ICHFriendsTableViewCellIdentity"
    
    var friendsArray: NSArray! = [["img": "img1", "name": "Anna"], ["img": "img2", "name": "Brant"]]
    var sectionTitleAry: NSArray! = ["A", "B"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
        let cellNib = UINib.init(nibName: "ICHFriendsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: ICHFriendsTableViewCellIdentity)
    }

}

extension ICHFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        let cellDict: NSDictionary = self.friendsArray[indexPath.section] as! NSDictionary
        cell.imgView?.image = UIImage.init(named: cellDict["img"] as! String)
        cell.nameLabel.text = cellDict["name"] as? String
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitleAry as? [String]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
