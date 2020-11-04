//
//  DailymotionStreamQuality.swift
//  VideoParse
//
//  Created by lishengfeng on 2020/11/4.
//

import Foundation


public extension DailymotionStreamMap {
    enum StreamQuality: VideoStreamQuality {
        case p60
        case p120
        case p180
        case p240
        case p360
        case p480
        case p720
        case p1080
        case other

        init(_ value: String) {
            switch value {
            case "60":
                self = .p60
            case "120":
                self = .p120
            case "180":
                self = .p180
            case "240":
                self = .p240
            case "360":
                self = .p360
            case "480":
                self = .p480
            case "720":
                self = .p720
            case "1080":
                self = .p1080
            default:
                self = .other
            }
        }

        public var description: String {
            switch self {
            case .p60:
                return "60p"
            case .p120:
                return "120p"
            case .p180:
                return "180p"
            case .p240:
                return "240p"
            case .p360:
                return "360p"
            case .p480:
                return "540p"
            case .p720:
                return "720p"
            case .p1080:
                return "1080p"
            case .other:
                return "other"
            }
        }

        public var level: Int {
            get {
                switch self {
                case .p60:
                    return 1
                case .p120:
                    return 2
                case .p240:
                    return 3
                case .p360:
                    return 4
                case .p480:
                    return 5
                case .p720:
                    return 6
                case .p1080:
                    return 7
                default:
                    return 0
                }
            }
        }
    }
}
