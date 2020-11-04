//
//  StreamQuality.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation

public protocol VideoStreamQuality {
    var description: String { get }
    var level: Int { get }
}

public func == (x: VideoStreamQuality, y: VideoStreamQuality) -> Bool { return x.level == y.level }
public func < (x: VideoStreamQuality, y: VideoStreamQuality) -> Bool { return x.level < y.level }
