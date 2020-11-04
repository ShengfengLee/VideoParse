//
//  DailymotionStramMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public struct DailymotionStramMap: StramMap {
    public let videoId: String
    public let tags: [String]
    public let webUrl: String
    public let title: String
    public let duration: Int
    public let streamInfos: [StramInfo]

    ///获取m3u8文件路径
    public static func m3u8(from data: Data) -> String? {
        guard let dict = lsf_jsonToObject(data) as? [String: Any] else { return nil }
        guard let qualities = dict["qualities"] as? [String: Any] else { return nil }
        guard let auto = qualities["auto"] as? [[String: Any]] else { return nil }
        let m3u8Url = auto.first?["url"] as? String
        return m3u8Url
    }

    ///解析m3u8文件
    public static func analysis(m3u8: String) -> [StramInfo]? {
        let lines = m3u8.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        let infos = lines.filter { $0.contains("#EXT-X-STREAM-INF") }

        var stramInfos = [StramInfo]()
        for item in infos {
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
            if let info = StramInfo(dict) {
                stramInfos.append(info)
            }
        }
        if stramInfos.count > 0 {
            return stramInfos
        }
        return nil
    }

    public init?(_ data: Data, streamInfos: [StramInfo]) {
        guard let dict = lsf_jsonToObject(data) as? [String: Any] else { return nil }

        guard let title = dict["title"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let id = dict["id"] as? String else { return nil }
        guard let duration = dict["duration"] as? Int else { return nil }
        guard let tags = dict["tags"] as? [String] else { return nil }

        self.videoId = id
        self.webUrl = url
        self.title = title
        self.duration = duration
        self.tags = tags

        self.streamInfos = streamInfos
    }
}


public extension DailymotionStramMap {
    struct StramInfo {
        let codecs: String
        let resolution: String
        let name: String
        let uri: String

        public init?(_ dict: [String: Any]) {

            guard let codecs = dict["CODECS"] as? String else { return nil }
            guard let resolution = dict["RESOLUTION"] as? String else { return nil }
            guard let name = dict["NAME"] as? String else { return nil }
            guard let uri = dict["PROGRESSIVE-URI"] as? String else { return nil }

            self.codecs = codecs
            self.resolution = resolution
            self.name = name
            self.uri = uri
        }
    }
}
