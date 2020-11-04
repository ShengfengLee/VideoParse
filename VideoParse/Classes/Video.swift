//
//  Video.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation


struct Video {
    enum VideoSource {
        case youtube
        case local
        case h5
    }

    enum Entity {
        case youtube(YoutubeStreamMap)
        case local(path: URL)
        case h5(url: String)
        case dailyMotion(DailymotionStreamMap)
        case vimeo(VimeoStreamMap)


        var videoResource: URL? {
            switch self {
            case .h5(let url):
                return URL(string: url)

            case .youtube(let youtubeStream):
                if let path = youtubeStream.streamDatas.first?.url, let url = URL(string: path) {
                    return url
                }
                return nil

            case .dailyMotion(let dailymotionStreamMap):
                if let path = dailymotionStreamMap.streamDatas.first?.uri, let url = URL(string: path) {
                    return url
                }
                return nil


            case .vimeo(let vimeoStreamMap):
                if let path = vimeoStreamMap.streamDatas.first?.url, let url = URL(string: path) {
                    return url
                }
                return nil
            case .local(let path):
                return path
            }
        }
    }




    static func parse(url: URL?, html: String?, source: VideoSource = .h5, complete: ((Entity?) -> Void)?) {

        //先判断是不是youtube
        if YoutubeParse.validVideoId(from: url) {
            YoutubeParse.video(from: url) { (streamMap) in
                if let video = streamMap as? YoutubeStreamMap {
                    complete?(Entity.youtube(video))
                }
                //解析失败，按照H5模式再试一次
                else {
                    //解析网页
                    let video = self.parse(html: html)
                    complete?(video)
                }

                return
            }
        }


        //判断是不是Dailymotion
        if DailymotionParse.validVideoId(from: url) {
            DailymotionParse.video(from: url) { (streamMap) in
                if let video = streamMap as? DailymotionStreamMap {
                    complete?(Entity.dailyMotion(video))
                }
                //解析失败，按照H5模式再试一次
                else {
                    //解析网页
                    let video = self.parse(html: html)
                    complete?(video)
                }

                return
            }
        }



        //判断是不是Vimeo
        if VimeoParse.validVideoId(from: url) {
            VimeoParse.video(from: url) { (streamMap) in
                if let video = streamMap as? VimeoStreamMap {
                    complete?(Entity.vimeo(video))
                }
                //解析失败，按照H5模式再试一次
                else {
                    //解析网页
                    let video = self.parse(html: html)
                    complete?(video)
                }

                return
            }
        }


        //解析网页
        let video = self.parse(html: html)
        complete?(video)
    }


    ///根据网页解析视频URL
    static func parse(html: String?) -> Entity? {
        guard let html = html else { return nil }
        if let url = HTMLParse.parseVideo(for: html) {
            return Entity.h5(url: url)
        }
        return nil
    }
}
