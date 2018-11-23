//
//  JSJAPI.swift
//  ichat
//
//  Created by Inbasis on 2018/11/23.
//  Copyright © 2018年 iChat. All rights reserved.
//

import Foundation
import Moya
import SVProgressHUD
import HandyJSON

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

let loadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = topVC else { return }
    switch type {
    case .began:
        SVProgressHUD.show()
    case .ended:
        SVProgressHUD.dismiss()
    }
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<OOMApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

// 初始化 OOMApi 请求的 provider
let OOMProvider = MoyaProvider<OOMApi>(requestClosure: timeoutClosure)
let OOMLoadingProvider = MoyaProvider<OOMApi>(requestClosure: timeoutClosure, plugins: [loadingPlugin])

/** 下面定义 OOMApi 请求的 endpoints（供 provider 使用）**/

// 请求分类
public enum OOMApi {
    case doLogin(username: String, password: String) // 登录
    case getUserDetail() // 用户信息
    case getFriendsList() // 获取好友列表
}

// 请求配置
extension OOMApi: TargetType {
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "http://123.56.98.99:2080/zpm-admin")! // 测试
    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .doLogin:
            return "/api/login/dologin"
            
        case .getUserDetail:
            return "/app/detail"
            
        case .getFriendsList:
            return "/api/friends/list"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .get
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case .doLogin(let username, let password):
            params["loginName"] = username
            params["password"] = password
            break
        case .getUserDetail: break

            
        case .getFriendsList: break

            
        default:
            break
        }
        print(params)
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        let tokenStr = UserDefaults.standard.string(forKey: TokenString)
        if (tokenStr != nil) {
            return ["sid": tokenStr!]
        }
        
        return nil
    }
}
