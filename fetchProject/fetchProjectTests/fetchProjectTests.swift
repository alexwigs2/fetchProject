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
    var viewModel: RecipesViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.cacheManager = ImageCacheManager.shared
        self.testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f18384e7-3da7-4714-8f09-bbfa0d2c8913/large.jpg")!
        self.mockNetworkService = MockNetworkService()
        self.viewModel = RecipesViewModel(networkService: mockNetworkService)
        
        // clear cache before each test
        self.clearCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func clearCache() {
        let fileManager = FileManager.default
        if let cachedFileURL = cacheManager.cachedImageURL(for: testURL) {
            try? fileManager.removeItem(at: cachedFileURL)
        }
    }
    
    func testImageDownloading() {
        let expectation = self.expectation(description: "Image download should complete")
        
        // create mock image
        guard let mockImage = UIImage(systemName: "star.fill") else {
            XCTFail("Test image creation failed")
            return
        }
        
        guard let mockImageData = mockImage.pngData() else {
            XCTFail("Failed to create image data")
            return
        }
        
        self.mockNetworkService.mockData = mockImageData
        self.mockNetworkService.mockResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.mockNetworkService.mockError = nil
        
        // try downloading image
        self.cacheManager.downloadImage(from: testURL) { image in
            XCTAssertNotNil(image, "The image should be downloaded successfully.")
            
            // check if image was saved to cache
            if let cachedFileURL = self.cacheManager.cachedImageURL(for: self.testURL) {
                XCTAssertTrue(FileManager.default.fileExists(atPath: cachedFileURL.path), "The image should be saved in the cache.")
            } else {
                XCTFail("Cached file URL should not be nil.")
            }
            
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testImageLoadingFromCache() {
        let expectation = self.expectation(description: "Image loading from cache should complete")
        
        // download image and then load it from the cache
        self.cacheManager.downloadImage(from: testURL) { image in
            if let image = image {
                if let cachedImage = self.cacheManager.loadImageFromCache(for: self.testURL) {
                    XCTAssertNotNil(cachedImage, "The image should be loaded from the cache.")
                    expectation.fulfill()
                } else {
                    // if loading from cache fails
                    XCTFail("The image should have been cached. Cache path: \(self.cacheManager.cachedImageURL(for: self.testURL)?.path ?? "Unknown path")")
                }
            } else {
                // if download fails
                XCTFail("Image download failed.")
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
        
        // download first image and then download another one and load it from the cache
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

    func testGetData_SuccessfulResponse() {
        let mockJSON = """
            {
                "recipes": [
                    {
                        "cuisine": "Italian",
                        "name": "Pasta",
                        "photo_url_large": "url_large",
                        "photo_url_small": "url_small",
                        "uuid": "12345",
                        "source_url": "source_url",
                        "youtube_url": "youtube_url"
                    }
                ]
            }
            """.data(using: .utf8)
        
        self.mockNetworkService.mockData = mockJSON
        self.mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        let expectation = self.expectation(description: "Data should be fetched and parsed")
        
        self.viewModel.getData { recipeArray in
            XCTAssertEqual(recipeArray.count, 1)
            XCTAssertEqual(recipeArray.first?["name"] as? String, "Pasta")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetData_ErrorResponse() {
        self.mockNetworkService.mockData = nil
        self.mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
                                                          statusCode: 500,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        self.mockNetworkService.mockError = nil
        
        let expectation = self.expectation(description: "Data fetch should handle error")
        
        self.viewModel.getData { recipeArray in
            XCTAssertEqual(recipeArray.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class MockNetworkService: NetworkService {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func fetchData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let error = mockError {
            completion(nil, nil, error)
        } else {
            completion(mockData, mockResponse, nil)
        }
    }
}
