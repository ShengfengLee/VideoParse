//
//  VimeoParse.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public class VimeoParse: StreamParse {

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

        if host.contains("vimeo.com"), pathComponents.count > 0 {
            return pathComponents.last
        }
        return nil
    }

    ///根据视频id获取视频详情
    private class func parse(with videoId: String, complete: ((VimeoStreamMap?) -> Void)?) {
        let urlStr = "https://player.vimeo.com/video/\(videoId)/config"
        guard let url = URL(string: urlStr) else {
            complete?(nil)
            return
        }
        let request = URLRequest(url: url)
        DailymotionStreamMap.fetch(request) { (data, _, error) in
            guard let data = data else {
                complete?(nil)
                return
            }

            let map = VimeoStreamMap(data)
            complete?(map)
        }
    }
}
