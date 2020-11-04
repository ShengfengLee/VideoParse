//
//  VideoParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation


struct VideoParse {
    ///根据url解析
    static func parse(url: URL, complete: @escaping (StreamBaseMap?) -> Void) {
        self.parse(url: url, html: nil, complete: complete)
    }

    ///根据HTML网页内容解析
    static func parse(html: String, complete: @escaping (StreamBaseMap?) -> Void) {
        self.parse(url: nil, html: html, complete: complete)
    }

    static func parse(url: URL?, html: String?, complete: @escaping (StreamBaseMap?) -> Void) {
        if let url = url {
            let parses: [StreamParse.Type] = [YoutubeParse.self, DailymotionParse.self, VimeoParse.self]
            for parse in parses {
                if parse.validVideoId(from: url) == false { continue }
                parse.video(from: url) { (streamMap) in
                    if let video = streamMap as? YoutubeStreamMap {
                        complete(video)
                    }
                    //解析失败，按照H5模式再试一次
                    else {
                        //解析网页
                        HTMLParse.video(from: html, complete: complete)
                    }
                }
                return
            }
        }

        //解析网页
        HTMLParse.video(from: html, complete: complete)
    }
}
