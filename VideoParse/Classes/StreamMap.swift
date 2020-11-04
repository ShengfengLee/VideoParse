//
//  StreamMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation

public enum StreamSource {
    case youtube
    case dailyMotion
    case vimeo
    case h5
}

///视频流
public protocol StreamingData {
    var url: String { get }
}

public protocol StreamBaseMap {
    ///视频流列表
    var streamDatas: [StreamingData] { get }
    var source: StreamSource { get }

    ///清晰度最高的视频流地址
//    var highestStreamUrl: String { get }
    ///默认第一个视频流地址
    var defualtStreamUrl: String { get }
}
extension StreamBaseMap {
    public var defualtStreamUrl: String { return streamDatas.first!.url }
}

///网络视频对象
public protocol StreamMap: StreamBaseMap {
    ///视频id
    var videoId: String { get }
    ///网页
    var webUrl: String { get }
    ///视频标题
    var title: String { get }
    ///视频时长
    var duration: Int { get }
    ///视频封面列表
    var thumbnails: [StreamThumbnail] { get }
}


extension StreamMap {
    static func fetch(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

