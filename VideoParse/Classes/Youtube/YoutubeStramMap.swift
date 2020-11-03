//
//  YoutubeStramMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

public struct YoutubeStramMap {
    public let host: String
    public let pageType: String

    public let videoDetails: VideoDetails
    public let streamingData: [StreamingData]

    public init?(_ dict: [String: String]) {
        guard let vss_host = dict["vss_host"] else { return nil }
        guard let csi_page_type = dict["csi_page_type"] else { return nil }
        guard let player_response = dict["player_response"] else { return nil }
        guard let response = lsf_jsonToObject(player_response) as? [String : Any] else { return nil }

        self.host = vss_host
        self.pageType = csi_page_type

        //视频详情
        guard let dic = response["videoDetails"] as? [String: Any] else { return nil }
        guard let details = VideoDetails(dic) else { return nil }
        self.videoDetails = details

        //视频流
        guard let streamingData = response["streamingData"] as? [String: Any] else { return nil }
        var list = [StreamingData]()
        var allFormats = [[String: Any]]()
        if let formats = streamingData["formats"] as? [[String: Any]] {
            allFormats.append(contentsOf: formats)
        }
        if let adaptiveFormats = streamingData["adaptiveFormats"] as? [[String: Any]] {
            allFormats.append(contentsOf: adaptiveFormats)
        }
        allFormats.forEach({
            if let data = StreamingData($0) {
                list.append(data)
            }
        })
        self.streamingData = list
    }
}

public extension YoutubeStramMap {
    struct VideoDetails {
        let videoId: String
        let title: String
        let lengthSeconds: Int?
        let keywords: [String]?
        let shortDescription: String?
        let thumbnails: [Thumbnail]?

        public init?(_ dict: [String: Any]) {
            guard let videoId = dict["videoId"] as? String else { return nil }
            guard let title = dict["title"] as? String else { return nil }
            guard let lengthSeconds = dict["lengthSeconds"] as? String else { return nil }

            let keywords = dict["keywords"] as? [String]
            let shortDescription = dict["shortDescription"] as? String


            self.videoId = videoId
            self.title = title
            self.lengthSeconds = Int(lengthSeconds)
            self.keywords = keywords
            self.shortDescription = shortDescription

            let thumbnail = dict["thumbnail"] as? [String: Any]
            let thumbnails = thumbnail?["thumbnails"] as? [[String: Any]]


            //封面
            var list = [Thumbnail]()
            thumbnails?.forEach({
                if let thumbnail = Thumbnail($0) {
                    list.append(thumbnail)
                }
            })
            self.thumbnails = list
        }
    }
}


public extension YoutubeStramMap.VideoDetails {

    struct Thumbnail {
        let url: String
        let width: Float
        let height: Float

        public init?(_ dict: [String: Any]) {
            guard let url = dict["url"] as? String else { return nil }
            guard let width = dict["width"] as? Float else { return nil }
            guard let height = dict["height"] as? Float else { return nil }

            self.url = url
            self.width = width
            self.height = height
        }
    }
}

public extension YoutubeStramMap {
    struct StreamingData {
        let url: String
        let mimeType: String
        let width: Float
        let height: Float
        let quality: StreamingQuality
        let fps: Int
        let qualityLabel: String


        public init?(_ dict: [String: Any]) {
            guard let url = dict["url"] as? String else { return nil }
            guard let mimeType = dict["mimeType"] as? String else { return nil }
            guard let width = dict["width"] as? Float else { return nil }
            guard let height = dict["height"] as? Float else { return nil }
            guard let quality = dict["quality"] as? String else { return nil }
            guard let fps = dict["fps"] as? Int else { return nil }
            guard let qualityLabel = dict["qualityLabel"] as? String else { return nil }

            self.url = url
            self.mimeType = mimeType
            self.width = width
            self.height = height
            self.quality = StreamingQuality(quality) 
            self.fps = fps
            self.qualityLabel = qualityLabel
        }
    }

}

public func FormatStreamMapFromString(_ string: String) -> YoutubeStramMap? {
    let dict = string.yy_toDict()
    let stram = YoutubeStramMap(dict)
    return stram
}
