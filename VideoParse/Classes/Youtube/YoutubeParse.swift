//
//  YoutubeParse.swift
//  YOYOVideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation


public class YoutubeParse: StreamParse {

    private static let kUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"
    private static let kYoutubeInfoURL = "https://www.youtube.com/get_video_info?video_id="

    ///根据URL获取youtube视频详情
    public class func video(from url: URL?, complete: ((StreamMap?) -> Void)?) {
        guard let url = url, let videoId = self.videoId(from: url) else {
            complete?(nil)
            return
        }

        self.parse(with: videoId, complete: complete)
    }


    ///根据URL解析youtube视频videoId
    public class func videoId(from url: URL?) -> String? {
        guard let url = url, let host = url.host else {
            return nil
        }
        let pathComponents = url.pathComponents
        let absoluteString = url.absoluteString

        if host == "youtu.be", pathComponents.count > 1 {
            return pathComponents[1]
        }

        if absoluteString.contains("www.youtube.com/embed"), pathComponents.count > 2 {
            return pathComponents[2]
        }

        if host == "youtube.googleapis.com", pathComponents.count > 2 {
            return pathComponents[2]
        }

        if host == "www.youtube.com", pathComponents.count > 2 {
            return pathComponents[2]
        }

        if let queryDic = url.yy_dictionaryForQuery(), let param = queryDic["v"] as? String {
            return param
        }

        return nil
    }
    
    ///根据视频id获取视频详情
    private class func parse(with videoId: String, complete: ((YoutubeStreamMap?) -> Void)?) {
        let urlStr = kYoutubeInfoURL + videoId
        guard let url = URL(string: urlStr) else {
            complete?(nil)
            return
        }

        var request = URLRequest(url: url)
        request.setValue(kUserAgent, forHTTPHeaderField: "User-Agent")
        DailymotionStreamMap.fetch(request) { (data, _, error) in
            guard let data = data else {
                complete?(nil)
                return
            }
            let map = YoutubeStreamMap(data)
            complete?(map)
        }
    }
}
