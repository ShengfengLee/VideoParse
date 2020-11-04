//
//  DailymotionStreamMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public struct DailymotionStreamMap: StreamMap {
    public let videoId: String
    public let webUrl: String
    public let title: String
    public let duration: Int
    public var thumbnails: [StreamThumbnail]
    public let streamDatas: [StreamingData]
    public var source: StreamSource { return .dailyMotion }

    public let tags: [String]?

    public init?(_ data: Data, streamDatas: [StreamData]) {
        guard let dict = lsf_jsonToObject(data) as? [String: Any] else { return nil }

        guard let title = dict["title"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let id = dict["id"] as? String else { return nil }
        guard let duration = dict["duration"] as? Int else { return nil }
        let tags = dict["tags"] as? [String]

        self.videoId = id
        self.webUrl = url
        self.title = title
        self.duration = duration
        self.tags = tags


        ///封面
        guard let posters = dict["posters"] as? [String: String] else { return nil }
        self.thumbnails = posters.compactMap { Thumbnail($0.key, $0.value) }

        self.streamDatas = streamDatas
    }


    ///获取m3u8文件路径
    public static func m3u8(from data: Data) -> String? {
        guard let dict = lsf_jsonToObject(data) as? [String: Any] else { return nil }
        guard let qualities = dict["qualities"] as? [String: Any] else { return nil }
        guard let auto = qualities["auto"] as? [[String: Any]] else { return nil }
        let m3u8Url = auto.first?["url"] as? String
        return m3u8Url
    }

    ///解析m3u8文件
    public static func analysis(m3u8: String) -> [StreamData]? {
        let lines = m3u8.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        let datas = lines.filter { $0.contains("#EXT-X-STREAM-INF") }

        var streamDatas = [StreamData]()
        for item in datas {
            let dict = item.components(separatedBy: ",").reduce([:] as [String: String], {
                var d = $0
                let string = $1
                let subString = string.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
                if subString.count > 1 {
                    let key = "\(subString[0])"
                    let value = "\(subString[1])"
                    let newValue = value.replacingOccurrences(of: "\"", with: "")
                    d[key] = newValue
                }
                return d
            })
            if let data = StreamData(dict) {
                streamDatas.append(data)
            }
        }
        if streamDatas.count > 0 {
            return streamDatas
        }
        return nil
    }

}


public extension DailymotionStreamMap {
    struct StreamData: StreamingData {
        public let codecs: String
        public let resolution: String
        public let name: String
        public let url: String

        public init?(_ dict: [String: Any]) {

            guard let codecs = dict["CODECS"] as? String else { return nil }
            guard let resolution = dict["RESOLUTION"] as? String else { return nil }
            guard let name = dict["NAME"] as? String else { return nil }
            guard let url = dict["PROGRESSIVE-URI"] as? String else { return nil }

            self.codecs = codecs
            self.resolution = resolution
            self.name = name
            self.url = url
        }
    }
}


public extension DailymotionStreamMap {

    struct Thumbnail: StreamThumbnail {
        public let url: String
        public let quality: StreamQuality

        public init?(_ key: String, _ value: String) {
            self.quality = StreamQuality(key)
            self.url = value
        }
    }
}
