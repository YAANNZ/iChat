//
//  ICHChatViewController.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/21.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit
import MQTTClient

class ICHChatViewController: UIViewController {

    var contactModel: ContactModel!
    var onTopic: String!
    @IBOutlet weak var tableView: UITableView!
    var messageAry: NSMutableArray = []
    
    var sessionConnected = false
    var sessionError = false
    var sessionReceived = false
    var sessionSubAcked = false
    var mainSession: MQTTSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = contactModel.userName
        if contactModel.friendId == "bcea3927-9a58-11e8-abea-507b9d1edf44" {
            self.onTopic = "63242e46-4764-11e8-993a-507b9d1edf4"
        } else {
            self.onTopic = "bcea3927-9a58-11e8-abea-507b9d1edf44"
        }
        
        let transport = MQTTCFSocketTransport()
        transport.host = "123.56.98.99"
        transport.port = 1883
        
        let mainSession = MQTTSession()
        self.mainSession = mainSession
        mainSession?.transport = transport
        mainSession?.delegate = self
        mainSession?.connect(connectHandler: { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("成功")
            }
        })
        
        while !sessionConnected && !sessionError {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        mainSession?.subscribe(toTopic: self.contactModel.friendId, at: .atMostOnce, subscribeHandler: { (error, num) in            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("成功")
            }
        })
        
        while sessionConnected && !sessionError && !sessionSubAcked {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        
        
//        mainSession?.close(disconnectHandler: <#T##MQTTDisconnectHandler!##MQTTDisconnectHandler!##(Error?) -> Void#>)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        mainSession?.publishData("我是管理员".data(using: String.Encoding.utf8), onTopic: self.onTopic, retain: false, qos: .atMostOnce, publishHandler: { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("成功")
            }
        })
        
        while sessionConnected && !sessionError && !sessionReceived {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
    }
}

extension ICHChatViewController: MQTTSessionDelegate {
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            sessionConnected = true
        case .connectionClosed:
            sessionConnected = false
        default:
            sessionError = true
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        print("Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
        sessionReceived = true;
        
        let newStr = String(data: data!, encoding: String.Encoding.utf8)
        print(newStr as Any)
        self.messageAry.add(newStr)
        self.tableView.reloadData()
    }
    
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        sessionSubAcked = true;
    }
    
}

extension ICHChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = self.messageAry[indexPath.row] as! String
        return cell
    }
    
    
}
