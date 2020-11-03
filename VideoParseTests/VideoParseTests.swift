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
        guard let videoId = YoutubeParse.videoId(from: url) else { return }

        let documentOpenExpectation = self.expectation(description: "")
        YoutubeParse.parse(with: videoId, complete: { youtubeMap, error in
            if let error = error {
                print(error)
            }
            else if let map = youtubeMap {
                print(map)
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 300, handler: nil)
    }


    func testDailymotion() {
        
        guard let url = URL(string: "https://www.dailymotion.com/video/x7x774p?playlist=x6hzkw") else { return }
        guard let videoId = DailymotionParse.videoId(from: url) else { return }
    }

    func testFacebook() {
        let documentOpenExpectation = self.expectation(description: "")


        let videoId = "1071752269887808"
        let urlStr = "https://www.facebook.com/watch/?v=" + videoId
        guard let url = URL(string: urlStr) else { return }

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let request = NSMutableURLRequest(url: url)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
            if let error = error {
                print(error)
            } else if let data = data, let result = String(data: data, encoding: .utf8) {
                let map = FormatStreamMapFromString(result)
            }
            documentOpenExpectation.fulfill()
        })
        task.resume()

        self.waitForExpectations(timeout: 300, handler: nil)
    }
}
