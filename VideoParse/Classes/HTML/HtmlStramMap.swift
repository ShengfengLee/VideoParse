//
//  HtmlStramMap.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation

public struct HtmlStramMap: StreamBaseMap {
    ///视频流列表
    public var streamDatas: [StreamingData]
    public var source: StreamSource { return .h5 }

    public init?(_ url: String?) {
        guard let url = url else { return nil }
        self.streamDatas = [StreamData(url)]
    }


}

public extension HtmlStramMap {
    ///视频流
    struct StreamData: StreamingData {
        public let url: String
        init(_ url: String) {
            self.url = url
        }
    }
}


