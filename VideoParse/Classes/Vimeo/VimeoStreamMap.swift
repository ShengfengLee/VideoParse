//
//  VimeoStreamMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public class VimeoStreamMap: StreamMap {

    public let videoId: String
    public let webUrl: String
    public let title: String
    public let duration: Int
    public var thumbnails: [StreamThumbnail]
    public let streamDatas: [StreamingData]
    public var source: StreamSource { return .vimeo }


    public init?(_ data: Data) {
        guard let dict = lsf_jsonToObject(data) as? [String: Any] else { return nil }

        guard let video = dict["video"] as? [String: Any] else { return nil }
        guard let title = video["title"] as? String else { return nil }
        guard let url = video["url"] as? String else { return nil }


        if let idString = video["id"] as? String {
            self.videoId = idString
        }
        else if let idInt = video["id"] as? Int {
            self.videoId = "\(idInt)"
        }
        else {
            return nil
        }

        if let duration = video["duration"] as? String {
            self.duration = Int(duration) ?? 0
        }
        else if let duration = video["duration"] as? Int {
            self.duration = duration
        }
        else {
            self.duration = 0
        }

        self.webUrl = url
        self.title = title


        ///封面
        guard let thumbs = video["thumbs"] as? [String: String] else { return nil }
        self.thumbnails = thumbs.compactMap { Thumbnail($0.key, $0.value) }


        guard let request = dict["request"] as? [String: Any] else { return nil }
        guard let files = request["files"] as? [String: Any] else { return nil }
        guard let progressive = files["progressive"] as? [[String: Any]] else { return nil }
        let streamDatas = progressive.compactMap { StreamData($0) }
        self.streamDatas = streamDatas
    }
}


public extension VimeoStreamMap {
    struct StreamData: StreamingData {
        public let url: String
        public let mime: String
        public let width: Float
        public let height: Float
        public let quality: StreamQuality
        public let fps: Int


        public init?(_ dict: [String: Any]) {
            guard let url = dict["url"] as? String else { return nil }
            guard let mime = dict["mime"] as? String else { return nil }
            guard let width = dict["width"] as? Float else { return nil }
            guard let height = dict["height"] as? Float else { return nil }
            guard let quality = dict["quality"] as? String else { return nil }
            guard let fps = dict["fps"] as? Int else { return nil }

            self.url = url
            self.mime = mime
            self.width = width
            self.height = height
            self.quality = StreamQuality(quality)
            self.fps = fps
        }
    }
}


public extension VimeoStreamMap {

    struct Thumbnail: StreamThumbnail {
        public let url: String
        public let quality: StreamQuality

        public init?(_ key: String, _ value: String) {
            self.quality = StreamQuality(key)
            self.url = value
        }
    }
}




