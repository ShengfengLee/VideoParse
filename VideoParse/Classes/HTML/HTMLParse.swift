//
//  HTMLParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation
import SwiftSoup

public struct HTMLParse: StreamParse {
    public static func videoId(from url: URL?) -> String? {
        return nil
    }

    ///根据HTML获取视频详情
    public static func video(from source: Any?, complete: ((StreamBaseMap?) -> Void)?) {
        guard let html = source as? String else {
            complete?(nil)
            return
        }
        let streamMap = self.parseVideo(for: html)
        complete?(streamMap)
    }


    ///抓取网页的视频播放地址
    public static func parseVideo(for html: String) -> HtmlStramMap? {
        let result = try? self.getVideoAttribute(forKey: "src", html: html)
        return HtmlStramMap(result)
    }

    public enum ParseError: Error {
        case noElement
        case notFound
    }


    public static func getVideoAttribute(forKey key: String, html: String) throws -> String? {
        let document = try SwiftSoup.parse(html)
        ///查询video标签
        let videos = try document.select("video")
        for video in videos.array() {
            if let value = try? video.attr(key), value.count > 0 {
                return value
            }
        }
        throw ParseError.notFound
    }
}
