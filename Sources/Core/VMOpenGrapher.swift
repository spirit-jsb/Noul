//
//  VMOpenGrapher.swift
//  Noul
//
//  Created by max on 2021/10/14.
//

#if canImport(Foundation) && canImport(Combine)

import Foundation
import Combine

@dynamicMemberLookup
public struct VMOpenGrapher {
  
  private let _parser: VMOpenGraphParser = VMDefaultOpenGraphParser()
  
  private var _configuration = VMOpenGrapherConfiguration()
  
  private var _url: URL?
  private var _htmlString: String?
  
  public init(url: URL) {
    self._url = url
  }
  
  public init(htmlString: String) {
    self._htmlString = htmlString
  }
  
  public func parser() -> AnyPublisher<[VMOpenGraphMetadata: String], Error> {
    return Future<[VMOpenGraphMetadata: String], Error> { (promise) in
      if let htmlString = self._htmlString {
        let parserResult = self._parser.parser(htmlString: htmlString)
        
        promise(.success(parserResult))
      }
      else if let url = self._url {
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
        
        // 如果有自定义的 header 添加到 request 的 header 中
        if let customHeader = self._configuration.customHeader {
          customHeader.compactMapValues { $0 }.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
          }
        }
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
          if let error = error {
            promise(.failure(error))
          }
          else {
            guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse else {
              promise(.failure(VMOpenGraphError.unknown))
              return
            }
            
            if !(200 ..< 300).contains(urlResponse.statusCode) {
              promise(.failure(VMOpenGraphError.unexpectedStatusCode(urlResponse.statusCode)))
            }
            else {
              guard let htmlString = String(data: data, encoding: .utf8) else {
                promise(.failure(VMOpenGraphError.encodingError))
                return
              }
              
              let parserResult = self._parser.parser(htmlString: htmlString)
              promise(.success(parserResult))
            }
          }
        }
        
        dataTask.resume()
      }
      else {
        promise(.failure(VMOpenGraphError.incompleteContext))
      }
    }
    .eraseToAnyPublisher()
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<VMOpenGrapherConfiguration, Value>) -> ((Value) -> VMOpenGrapher) {
    var copiedSelf = self
    
    return { (newValue) in
      copiedSelf._configuration[keyPath: keyPath] = newValue
      return copiedSelf
    }
  }
}

public struct VMOpenGrapherConfiguration {
  
  public var customHeader: [String: String]?
}

#endif
