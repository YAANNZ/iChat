//
//  ICHTextField.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/21.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit

class ICHTextField: UITextField {

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: 0, width: 30, height: 44)
    }

}
