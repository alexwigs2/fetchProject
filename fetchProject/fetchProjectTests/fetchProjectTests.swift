//
//  fetchProjectTests.swift
//  fetchProjectTests
//
//  Created by Alex Wigsmoen on 4/5/25.
//

import XCTest
@testable import fetchProject
import SwiftUI

final class fetchProjectTests: XCTestCase {
    
    var cacheManager: ImageCacheManager!
    var testURL: URL!
    
    // add tests for data fetching and caching of images 

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.cacheManager = ImageCacheManager.shared
        self.testURL = URL(string: "https://example.com/test-image.png")!
        
        // Clear cache before each test
        self.clearCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func clearCache() {
        let fileManager = FileManager.default
        if let cachedFileURL = self.cacheManager.cachedImageURL(for: testURL) {
            try? fileManager.removeItem(at: cachedFileURL)
        }
    }

    func testImageDownloading() {
        let expectation = self.expectation(description: "Image download should complete")
        
        self.cacheManager.downloadImage(from: testURL) { image in
            XCTAssertNotNil(image, "The image should be downloaded successfully.")
            if let cachedFileURL = self.cacheManager.cachedImageURL(for: self.testURL) {
                XCTAssertTrue(FileManager.default.fileExists(atPath: cachedFileURL.path), "The image should be saved in the cache.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testImageLoadingFromCache() {
        let expectation = self.expectation(description: "Image loading from cache should complete")
      
        self.cacheManager.downloadImage(from: testURL) { _ in
            if let cachedImage = self.cacheManager.loadImageFromCache(for: self.testURL) {
                XCTAssertNotNil(cachedImage, "The image should be loaded from the cache.")
                expectation.fulfill()
            } else {
                XCTFail("The image should have been cached.")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNoImageCacheBeforeDownload() {
        if let cachedImage = self.cacheManager.loadImageFromCache(for: testURL) {
            XCTFail("There should be no image in the cache before downloading.")
        }
    }
    
    func testImageCacheAfterMultipleDownloads() {
        let expectation = self.expectation(description: "Image should be cached after multiple downloads")
        
        self.cacheManager.downloadImage(from: testURL) { _ in
            self.cacheManager.downloadImage(from: self.testURL) { _ in
                if let cachedImage = self.cacheManager.loadImageFromCache(for: self.testURL) {
                    XCTAssertNotNil(cachedImage, "The image should be cached after multiple downloads.")
                } else {
                    XCTFail("The image should have been cached.")
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
