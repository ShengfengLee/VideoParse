//
//  DailymotionParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

public class DailymotionParse {

    ///根据URL获取视频详情
    public class func video(from url: URL, complete: ((DailymotionStramMap?, Error?) -> Void)?) {
        guard let videoId = self.videoId(from: url) else {
            complete?(nil, nil)
            return
        }

    }


    ///根据URL解析视频videoId
    public class func videoId(from url: URL) -> String? {
        let pathComponents = url.pathComponents
        let absoluteString = url.absoluteString

        if absoluteString.contains("www.dailymotion.com/video/"), pathComponents.count > 2 {
            return pathComponents[2]
        }

        return nil
    }

    public class func parse(with url: URL, complete: ((DailymotionStramMap?, Error?) -> Void)?) {
        guard let videoId = self.videoId(from: url) else { return }
        guard let embedder = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .whitespaces) else { return }


        let metadataUrl = "https://www.dailymotion.com/player/metadata/video/\(videoId)?embedder=" + embedder + "&" + "referer=&app=com.dailymotion.neon&locale=en-US&client_type=website&section_type=player&component_style=_"


        guard let infoURL = URL(string: metadataUrl) else {
            complete?(nil, nil)
            return
        }

        //下载视频详情
        let request = URLRequest(url: infoURL)
        DailymotionStramMap.fetch(request) { (data, _, error) in
            guard let data = data else {
                complete?(nil, error)
                return
            }

            //下载m3u8文件
            if let m3u8Url = DailymotionStramMap.m3u8(from: data) {
                self.downloadM3U8(m3u8Url) { (string, error) in
                    guard let m3u8 = string else {
                        complete?(nil, error)
                        return
                    }

                    //解析m3u8文件
                    if let streamInfos = DailymotionStramMap.analysis(m3u8: m3u8) {
                        let map = DailymotionStramMap(data, streamInfos: streamInfos)
                        complete?(map, error)
                    }
                    else {
                        complete?(nil, error)
                    }
                }
            }
            else {
                complete?(nil, error)
            }
        }
    }

    ///下载m3u8文件
    private class func downloadM3U8(_ urlStr: String, complete: ((String?, Error?) -> Void)?) {
        guard let url = URL(string: urlStr) else {
            return
        }

        let request = URLRequest(url: url)
        DailymotionStramMap.fetch(request) { (data, _, error) in
            guard let m3u8Data = data else {
                complete?(nil, error)
                return
            }

            let string = String(data: m3u8Data, encoding: .utf8)
            complete?(string, error)
        }
    }

}


