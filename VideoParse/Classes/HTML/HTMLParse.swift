//
//  HTMLParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation
import SwiftSoup

public class HTMLParse {

    ///抓取网页的视频播放地址
    public class func parseVideo(for html: String) -> String? {
        let result = try? self.getVideoAttribute(forKey: "src", html: html)
        return result
    }

    public enum ParseError: Error {
        case noElement
        case notFound
    }


    public class func getVideoAttribute(forKey key: String, html: String) throws -> String? {
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
