//
//  VimeoStreamQuality.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public extension VimeoStreamMap {
    enum StreamQuality: VideoStreamQuality {
        case p240
        case p360
        case p540
        case p720
        case p1080
        case p1440
        case p2160
        case other
        case base

        init(_ quality: String) {
            let value = quality.replacingOccurrences(of: "p", with: "")
            switch value {
            case "240":
                self = .p240
            case "360":
                self = .p360
            case "540":
                self = .p540
            case "720":
                self = .p720
            case "1080":
                self = .p1080
            case "1440":
                self = .p1440
            case "2160":
                self = .p2160
            case "base":
                self = .base
            default:
                self = .other
            }
        }

        public var description: String {
            switch self {
            case .p240:
                return "240p"
            case .p360:
                return "360p"
            case .p540:
                return "540p"
            case .p720:
                return "720p"
            case .p1080:
                return "1080p"
            case .p1440:
                return "1440p"
            case .p2160:
                return "2160p"
            case .base:
                return "base"
            case .other:
                return "other"
            }
        }

        public var level: Int {
            get {
                switch self {
                case .p240:
                    return 1
                case .p360:
                    return 2
                case .p540:
                    return 3
                case .p720:
                    return 4
                case .p1080:
                    return 6
                case .p1440:
                    return 7
                case .p2160:
                    return 8
                case .base, .other:
                    return 0
                }
            }
        }
    }
}
