//
//  ICHFriendsViewController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/18.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit

class ICHFriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension ICHFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "123"
        return cell
    }
    
    
}
