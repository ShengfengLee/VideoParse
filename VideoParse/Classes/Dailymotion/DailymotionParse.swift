//
//  DailymotionParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

public class DailymotionParse: StreamParse {
    ///根据URL解析视频videoId
    public class func videoId(from url: URL?) -> String? {
        guard let url = url else { return nil }
        let pathComponents = url.pathComponents
        let absoluteString = url.absoluteString

        if absoluteString.contains("www.dailymotion.com/video/"), pathComponents.count > 2 {
            return pathComponents[2]
        }
        return nil
    }

    ///根据URL获取视频详情
    public class func video(from url: URL?, complete: ((StreamMap?) -> Void)?) {
        guard let url = url,
              let embedder = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .whitespaces),
              let videoId = self.videoId(from: url) else {
            complete?(nil)
            return
        }

        let metadataUrl = "https://www.dailymotion.com/player/metadata/video/\(videoId)?embedder=" + embedder + "&" + "referer=&app=com.dailymotion.neon&locale=en-US&client_type=website&section_type=player&component_style=_"


        guard let infoURL = URL(string: metadataUrl) else {
            complete?(nil)
            return
        }

        //下载视频详情
        let request = URLRequest(url: infoURL)
        DailymotionStreamMap.fetch(request) { (data, _, error) in
            guard let data = data else {
                complete?(nil)
                return
            }

            //下载m3u8文件
            if let m3u8Url = DailymotionStreamMap.m3u8(from: data) {
                self.downloadM3U8(m3u8Url) { (string) in
                    guard let m3u8 = string else {
                        complete?(nil)
                        return
                    }

                    //解析m3u8文件
                    if let streamDatas = DailymotionStreamMap.analysis(m3u8: m3u8) {
                        let map = DailymotionStreamMap(data, streamDatas: streamDatas)
                        complete?(map)
                    }
                    else {
                        complete?(nil)
                    }
                }
            }
            else {
                complete?(nil)
            }
        }
    }

    ///下载m3u8文件
    private class func downloadM3U8(_ urlStr: String, complete: ((String?) -> Void)?) {
        guard let url = URL(string: urlStr) else {
            complete?(nil)
            return
        }

        let request = URLRequest(url: url)
        DailymotionStreamMap.fetch(request) { (data, _, error) in
            guard let m3u8Data = data else {
                complete?(nil)
                return
            }

            let string = String(data: m3u8Data, encoding: .utf8)
            complete?(string)
        }
    }

}


