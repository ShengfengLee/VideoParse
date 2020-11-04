//
//  YoutubeStreamMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

public struct YoutubeStreamMap: StreamMap {
    public var videoId: String { return videoDetails.videoId }
    public var webUrl: String { return "https://www.youtube.com/watch?v=\(videoId)" }
    public var title: String { return videoDetails.title }
    public var duration: Int { return videoDetails.lengthSeconds }
    public var thumbnails: [StreamThumbnail] { return videoDetails.thumbnails }

    ///视频详情
    public let videoDetails: VideoDetails
    ///视频流列表
    public let streamDatas: [StreamData]
    public let host: String
    public let pageType: String

    public init?(_ data: Data) {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        let dict = string.yy_toDict()
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
        var list = [StreamData]()
        var allFormats = [[String: Any]]()
        if let formats = streamingData["formats"] as? [[String: Any]] {
            allFormats.append(contentsOf: formats)
        }
        if let adaptiveFormats = streamingData["adaptiveFormats"] as? [[String: Any]] {
            allFormats.append(contentsOf: adaptiveFormats)
        }
        allFormats.forEach({
            if let data = StreamData($0) {
                list.append(data)
            }
        })
        self.streamDatas = list
    }
}

public extension YoutubeStreamMap {
    struct VideoDetails {
        let videoId: String
        let title: String
        let lengthSeconds: Int
        let keywords: [String]?
        let shortDescription: String?
        let thumbnails: [Thumbnail]

        public init?(_ dict: [String: Any]) {
            guard let videoId = dict["videoId"] as? String else { return nil }
            guard let title = dict["title"] as? String else { return nil }
            guard let lengthSeconds = dict["lengthSeconds"] as? String else { return nil }

            let keywords = dict["keywords"] as? [String]
            let shortDescription = dict["shortDescription"] as? String


            self.videoId = videoId
            self.title = title
            self.lengthSeconds = Int(lengthSeconds) ?? 0
            self.keywords = keywords
            self.shortDescription = shortDescription

            //封面
            guard let thumbnail = dict["thumbnail"] as? [String: Any],
                  let thumbnails = thumbnail["thumbnails"] as? [[String: Any]] else { return nil }
            self.thumbnails = thumbnails.compactMap { Thumbnail($0) }
        }
    }
}


public extension YoutubeStreamMap.VideoDetails {

    struct Thumbnail: StreamThumbnail {
        public let url: String
        public let width: Float
        public let height: Float

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

public extension YoutubeStreamMap {
    struct StreamData {
        let url: String
        let mimeType: String
        let width: Float
        let height: Float
        let quality: StreamQuality
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
            self.quality = StreamQuality(quality) 
            self.fps = fps
            self.qualityLabel = qualityLabel
        }
    }
}
