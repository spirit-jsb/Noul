//
//  NoulTests.swift
//  NoulTests
//
//  Created by max on 2021/10/15.
//

import XCTest
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift

@testable import Noul

class NoulTests: XCTestCase {
  
  enum NoulTestsError: Error {
    case test
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  override func tearDown() {
    super.tearDown()
    
    self.cancellables.forEach { $0.cancel() }
  }
  
  func test_url() {
    let expectation = expectation(description: "test url")
    
    self.mockHtmlFile(htmlFilename: "ogp")
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    let test_url = URL(string: "https://www.mock.com")!
    
    VMOpenGrapher(url: test_url)
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == "The Rock")
      XCTAssert(og?[.url] == "https://www.imdb.com/title/tt0117500/")
      XCTAssert(og?[.image] == "https://ia.media-imdb.com/images/rock.jpg")
      XCTAssert(og?[.description] == "Sean Connery found fame and fortune as the suave, sophisticated British agent, James Bond.")
      
      XCTAssert(error == nil)
    }
  }
  
  func test_custom_header() {
    let expectation = expectation(description: "test custom header")
    
    self.mockHtmlFile(htmlFilename: "ogp")
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    let test_url = URL(string: "https://www.mock.com")!
    
    VMOpenGrapher(url: test_url)
      .customHeader(["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1"])
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == "The Rock")
      XCTAssert(og?[.url] == "https://www.imdb.com/title/tt0117500/")
      XCTAssert(og?[.image] == "https://ia.media-imdb.com/images/rock.jpg")
      XCTAssert(og?[.description] == "Sean Connery found fame and fortune as the suave, sophisticated British agent, James Bond.")
      
      XCTAssert(error == nil)
    }
  }
  
  func test_noul_request_error() {
    let expectation = expectation(description: "test noul request error")
    
    self.mockError(NoulTestsError.test)
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    let test_url = URL(string: "https://www.mock.com")!
    
    VMOpenGrapher(url: test_url)
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == nil)
      XCTAssert(og?[.url] == nil)
      XCTAssert(og?[.image] == nil)
      XCTAssert(og?[.description] == nil)
      
      XCTAssert((error! as NSError).domain == NoulTestsError.test._domain)
    }
  }
  
  func test_unexpected_status_code_error() {
    let expectation = expectation(description: "test noul request error")
    
    self.mockStatusCode(400)
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    let test_url = URL(string: "https://www.mock.com")!
    
    VMOpenGrapher(url: test_url)
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == nil)
      XCTAssert(og?[.url] == nil)
      XCTAssert(og?[.image] == nil)
      XCTAssert(og?[.description] == nil)
      
      XCTAssert((error as? VMOpenGraphError) == VMOpenGraphError.unexpectedStatusCode(400))
    }
  }
  
  func test_encoding_error() {
    let expectation = expectation(description: "test noul request error")
    
    self.mockUtf16String()
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    let test_url = URL(string: "https://www.mock.com")!
    
    VMOpenGrapher(url: test_url)
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == nil)
      XCTAssert(og?[.url] == nil)
      XCTAssert(og?[.image] == nil)
      XCTAssert(og?[.description] == nil)
      
      XCTAssert((error as? VMOpenGraphError) == VMOpenGraphError.encodingError)
    }
  }
  
  func test_html_string() {
    let expectation = expectation(description: "test noul request error")
    
    let test_bundle = Bundle(for: type(of: self))
    let test_ogp_html_file_path = test_bundle.path(forResource: "ogp", ofType: "html")!
    
    let test_ogp_html_file_url = URL(fileURLWithPath: test_ogp_html_file_path)
    
    let test_ogp_html_raw_data = try! Data(contentsOf: test_ogp_html_file_url)
    
    let test_ogp_html_string = String(data: test_ogp_html_raw_data, encoding: .utf8)!
    
    var error: Error?
    var og: [VMOpenGraphMetadata: String]?
    
    VMOpenGrapher(htmlString: test_ogp_html_string)
      .parser()
      .sink { (completion) in
        switch completion {
          case .failure(let _error):
            error = _error
          case .finished:
            break
        }
        
        expectation.fulfill()
      } receiveValue: { (_og) in
        og = _og
      }
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10) { _ in
      XCTAssert(og?[.title] == "The Rock")
      XCTAssert(og?[.url] == "https://www.imdb.com/title/tt0117500/")
      XCTAssert(og?[.image] == "https://ia.media-imdb.com/images/rock.jpg")
      XCTAssert(og?[.description] == "Sean Connery found fame and fortune as the suave, sophisticated British agent, James Bond.")
      
      XCTAssert(error == nil)
    }
  }
  
  func test_open_graph_parser() {
    var metaTags = "<meta property=\"og:description\" content=\"Sean Connery found fame and fortune as the suave.\" />"
    XCTAssertTrue(VMDefaultOpenGraphParser().parser(htmlString: metaTags)[.description] == "Sean Connery found fame and fortune as the suave.")
    
    metaTags = "<meta content=\"Sean Connery found fame and fortune as the suave.\" property=\"og:description\" />"
    XCTAssertTrue(VMDefaultOpenGraphParser().parser(htmlString: metaTags)[.description] == "Sean Connery found fame and fortune as the suave.")
    
    let brTags = "</br>"
    XCTAssertTrue(VMDefaultOpenGraphParser().parser(htmlString: brTags).isEmpty)
  }
  
  private func mockHtmlFile(htmlFilename: String) {
    OHHTTPStubsSwift.stub { (_) in
      return true
    } response: { (request) in
      let test_bundle = Bundle(for: type(of: self))
      let test_ogp_html_file_path = test_bundle.path(forResource: htmlFilename, ofType: "html")!
      
      let response = HTTPStubsResponse(fileAtPath: test_ogp_html_file_path, statusCode: 200, headers: nil)
      
      return response
    }
  }
  
  private func mockStatusCode(_ statusCode: Int32) {
    OHHTTPStubsSwift.stub { (_) in
      return true
    } response: { (request) in
      let response = HTTPStubsResponse()
      response.statusCode = statusCode
      
      return response
    }
  }
  
  private func mockError(_ error: Error) {
    OHHTTPStubsSwift.stub { (_) in
      return true
    } response: { (request) in
      let response = HTTPStubsResponse()
      response.error = error
      
      return response
    }
  }
  
  private func mockUtf16String() {
    OHHTTPStubsSwift.stub { (_) in
      return true
    } response: { (request) in
      let utf16String = "Hello World"
      let urt16RawData = utf16String.data(using: .utf16)!
      
      let response = HTTPStubsResponse(data: urt16RawData, statusCode: 200, headers: nil)
      
      return response
    }
  }
}

extension VMOpenGraphError: Equatable {
  
  public static func == (lhs: VMOpenGraphError, rhs: VMOpenGraphError) -> Bool {
    switch (lhs, rhs) {
      case (.incompleteContext, .incompleteContext), (.unknown, .unknown), (.encodingError, .encodingError):
        return true
      case (.unexpectedStatusCode(let lhsStatusCode), .unexpectedStatusCode(let rhsStatusCode)):
        return lhsStatusCode == rhsStatusCode
      default:
        return false
    }
  }
}
