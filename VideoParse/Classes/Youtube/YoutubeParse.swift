//
//  YoutubeParse.swift
//  YOYOVideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation


public class YoutubeParse {

    private static let kUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"
    private static let kYoutubeInfoURL = "https://www.youtube.com/get_video_info?video_id="

    ///根据URL获取youtube视频详情
    public class func video(from url: URL, complete: ((YoutubeStramMap?, Error?) -> Void)?) {
        guard let videoId = self.videoId(from: url) else {
            complete?(nil, nil)
            return
        }

        self.parse(with: videoId, complete: complete)
    }


    ///根据URL解析youtube视频videoId
    public class func videoId(from url: URL) -> String? {
        guard let host = url.host else {
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
    public class func parse(with videoId: String, complete: ((YoutubeStramMap?, Error?) -> Void)?) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        let urlStr = kYoutubeInfoURL + videoId
        if let infoURL = URL(string: urlStr) {
            let request = NSMutableURLRequest(url: infoURL)
            request.setValue(kUserAgent, forHTTPHeaderField: "User-Agent")
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
                if let error = error {
                    complete?(nil, error)
                } else if let data = data, let result = String(data: data, encoding: .utf8) {
                    let map = FormatStreamMapFromString(result)
                    complete?(map, nil)
                }
                else {
                    complete?(nil, nil)
                }
            })
            task.resume()
        }
        else {
            complete?(nil, nil)
        }
    }
}
