//
//  StreamParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation

public protocol StreamParse {
    static func validVideoId(from url: URL?) -> Bool
    ///根据URL解析视频videoId
    static func videoId(from url: URL?) -> String?
    ///根据URL、或者HTML获取视频详情
    static func video(from source: Any?, complete: ((StreamBaseMap?) -> Void)?)
}

public extension StreamParse {
    ///根据url判断是否有有效的video id
    static func validVideoId(from url: URL?) -> Bool {
        guard let url = url else { return false }
        guard let videoId = self.videoId(from: url) else { return false }
        return videoId.count > 0
    }
}
