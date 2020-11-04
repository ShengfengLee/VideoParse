//
//  VideoParseTests.swift
//  VideoParseTests
//
//  Created by lishengfeng on 2020/11/3.
//

import XCTest
@testable import VideoParse

class VideoParseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testYouTube() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=6RLRcN2aJAo") else { return }
        let documentOpenExpectation = self.expectation(description: "")
        YoutubeParse.video(from: url, complete: { streamMap in
            if let map = streamMap as? YoutubeStreamMap {
                print(map)
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 300, handler: nil)
    }


    func testDailymotion() {
        guard let url = URL(string: "https://www.dailymotion.com/video/x7x774p") else { return }
        let documentOpenExpectation = self.expectation(description: "")
        DailymotionParse.video(from: url, complete: { streamMap in
            if let map = streamMap as? DailymotionStreamMap {
                print(map)
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 300, handler: nil)
    }

    func testVimeo() {
        guard let url = URL(string: "https://vimeo.com/452638847") else { return }
        let documentOpenExpectation = self.expectation(description: "")
        VimeoParse.video(from: url, complete: { streamMap in
            if let map = streamMap as? VimeoStreamMap {
                print(map)
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 300, handler: nil)
    }
}
