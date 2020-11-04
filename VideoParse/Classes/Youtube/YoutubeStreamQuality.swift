//
//  StreamingQuality.swift
//  YOYOVideoParse
//
//  Created by lishengfeng on 2020/11/3.
//

import Foundation


extension YoutubeStreamMap {
    public enum StreamQuality: VideoStreamQuality {
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

        public var description: String {
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

        public var level: Int {
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
                    return 0
                }
            }
        }
    }
}
