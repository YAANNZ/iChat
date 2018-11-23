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
    case isPastDue(user: String) // 验证 cookie 是否过期
    case getAmounts(user: String) // 集团端首页图表展示
    case getQtNum // 集团全部机组启停数
    case getQuotaList(user: String, orgId: String) // 电厂机组负荷率
    case getJzqt(pagenum: String, pagesize: String, orgid: String, g_id: String, type: String, qt_desc: String, starttime: String, endtime: String, name: String) // 获取机组启停数据
    case getAllOrg // 获得所有有效电厂
}

// 请求配置
extension OOMApi: TargetType {
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "http://123.56.98.99:2080/zpm-admin/api")! // 测试
    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .isPastDue:
            return "/login/isPastDue"
            
        case .getAmounts:
            return "/syzb/getAmounts"
            
        case .getQtNum:
            return "/syzb/getQtNum"
            
        case .getQuotaList:
            return "/syzb/getQuotaList"
            
        case .getJzqt:
            return "/jzqt/getJzqt"
            
        case .getAllOrg:
            return "/jzqt/getAllOrg"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .post
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case .isPastDue(let user):
            params["user"] = user
            
        case .getAmounts(let user):
            params["user"] = user
            
        case .getQtNum:
            params["user"] = "zhourui"
            
        case .getQuotaList(let user, let orgId):
            params["user"] = user
            params["orgId"] = orgId
            
        case .getJzqt(let pagenum, let pagesize, let orgid, let g_id, let type, let qt_desc, let starttime, let endtime, let name):
            params["user"] = "zhourui"
            params["pagenum"] = pagenum
            params["pagesize"] = pagesize
            params["orgId"] = orgid
            params["g_id"] = g_id
            params["type"] = type
            params["qt_desc"] = qt_desc
            params["starttime"] = starttime
            params["endtime"] = endtime
            params["name"] = name
            
        case .getAllOrg:
            params["user"] = "zhourui"
            
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
        return ["Cookie": "zhourui=%7B%22time%22%3A%221542010959259%22%2C%22age%22%3A%22123%22%2C%22name%22%3A%22zhourui%22%2C%22type%22%3A%22type%22%7D;Max-Age=2592000"]
    }
}
