//
//  StramMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public protocol StramMap {
    var videoId: String { get }
    var tags: [String] { get }
    var webUrl: String { get }
    var title: String { get }
}

extension StramMap {
    static func fetch(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

