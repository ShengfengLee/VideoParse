//
//  YoYo+String.swift
//  YOYOVideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

extension URL {
    ///获取URL的参数
    func yy_dictionaryForQuery() -> [String: Any]? {
        if let query = self.query {
            return query.yy_queryStringComponents()
        }

        let result = self.absoluteString.components(separatedBy: "?")
        if result.count > 1 {
            return result.last?.yy_queryStringComponents()
        }

        return nil
    }
}

extension String {
    func yy_toDict() -> [String: String] {
        return self.components(separatedBy: "&").reduce([:] as [String: String], {
            var d = $0
            let components = $1.components(separatedBy: "=")
            if components.count == 2 {
                if let key = (components[0] as NSString).removingPercentEncoding, let value = (components[1] as NSString).removingPercentEncoding {
                    d[key] = value
                }
            }
            return d
        })
    }


    func yy_decodingURL() -> String {
        let result = self.replacingOccurrences(of: "+", with: " ")
        return result.removingPercentEncoding ?? result
    }

    //解析键值对
    func yy_queryStringComponents() -> [String: Any] {

        var dict = [String: AnyObject]()
        let pairs = self.components(separatedBy: "&")
        for pair in pairs {
            let components = pair.components(separatedBy: "=")
            if components.count > 1 {
                let key = components[0].yy_decodingURL()
                let value = components[1].yy_decodingURL()
                dict[key] = value as AnyObject
            }
        }
        return dict
    }
}

///Json转对象
func lsf_jsonToObject(_ obj: Any?) -> Any? {
    var data = obj as? Data

    if let string = obj as? String {
        data = string.data(using: String.Encoding.utf8)
    }

    if let data = data {
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)

        return object
    }
    return nil

}
