//
//  ICHModel.swift
//  ichat
//
//  Created by Inbasis on 2018/11/23.
//  Copyright © 2018年 iChat. All rights reserved.
//

import Foundation
import HandyJSON

// 启停机组模型
struct ContactModel: HandyJSON {
    var userName: String?
    var profilePhoto: String?
    var friendId: String?
    var userId: String?
    var createDate: String?
}
