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
        case youtube(YoutubeStramMap)
        case local(path: URL)
        case h5(url: String)


        var videoResource: URL? {
            switch self {
            case .h5(let url):
                return URL(string: url)

            case .youtube(let youtubeStram):
                if let path = youtubeStram.streamingData.first?.url, let url = URL(string: path) {
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
        if let url = url, let youtubeVideoId = YoutubeParse.videoId(from: url) {
            //解析youtube视频
            YoutubeParse.parse(with: youtubeVideoId) { (youtubeVideo, _) in
                if let video = youtubeVideo {
                    complete?(Entity.youtube(video))
                }
                //解析失败，按照H5模式再试一次
                else {
                    //解析网页
                    let video = self.parse(html: html)
                    complete?(video)
                }
            }
            return
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
