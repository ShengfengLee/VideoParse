//
//  StreamingQuality.swift
//  YOYOVideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation

public enum StreamingQuality: Comparable {
    case small
    case medium
    case large
    case hd720
    case other

    init(_ value: String) {
        switch value {
        case "small":
            self = .small
        case "medium":
            self = .medium
        case "large":
            self = .large
        case "hd720":
            self = .hd720
        default:
            self = .other
        }
    }

    var string: String {
        get {
            switch self {
            case .small:
                return "small"
            case .medium:
                return "medium"
            case .large:
                return "large"
            case .hd720:
                return "hd720"
            default:
                return "other"
            }
        }
    }

    var level: Int {
        get {
            switch self {
            case .small:
                return 1
            case .medium:
                return 2
            case .large:
                return 3
            case .hd720:
                return 4
            default:
                return 5
            }
        }
    }
}

public func == (x: StreamingQuality, y: StreamingQuality) -> Bool { return x.level == y.level }
public func < (x: StreamingQuality, y: StreamingQuality) -> Bool { return x.level < y.level }
