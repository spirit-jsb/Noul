//
//  VMOpenGraphParser.swift
//  Noul
//
//  Created by max on 2021/10/14.
//

#if canImport(Foundation)

import Foundation

protocol VMOpenGraphParser {
  
  func parser(htmlString: String) -> [VMOpenGraphMetadata: String]
}

extension VMOpenGraphParser {
  
  func parser(htmlString: String) -> [VMOpenGraphMetadata: String] {
    // 提取 meta 标签的正则表达式
    let metaTagRegex = try! NSRegularExpression(pattern: #"<meta(?:".*?"|'.*?'|[^'"])*?>"#, options: [.dotMatchesLineSeparators])
    
    // 提取 meta 标签
    let metaTagMatchResults = metaTagRegex.matches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.count))
    
    // 如果 meta 标签不存在, 则返回空字典
    guard !metaTagMatchResults.isEmpty else {
      return [:]
    }
    
    // 提取 property & content 标签的正则表达式
    let propertyTagRegex = try! NSRegularExpression(pattern: #"\sproperty=(?:"|')og:([a-zA-Z:]+)(?:"|')"#, options: [])
    let contentTagRegex = try! NSRegularExpression(pattern: #"\scontent=(?:"|')(.*?)(?:"|')"#, options: [])
    
    let parserResults = metaTagMatchResults.reduce([VMOpenGraphMetadata: String]()) { (attributes, metaTagMatchResult: NSTextCheckingResult) -> [VMOpenGraphMetadata: String] in
      var copiedAttributes = attributes
      
      let openGraphResult = { () -> (property: String, content: String)? in
        guard let metaTagRange = Range(metaTagMatchResult.range(at: 0), in: htmlString) else {
          return nil
        }
        
        let metaTag = String(htmlString[metaTagRange])
        
        // 提取 property 标签 range
        let propertyTagMatchResults = propertyTagRegex.matches(in: metaTag, options: [], range: NSRange(location: 0, length: metaTag.count))
        guard let firstPropertyTagMatchResult = propertyTagMatchResults.first, let propertyTagRange = Range(firstPropertyTagMatchResult.range(at: 1), in: metaTag) else {
          return nil
        }
        
        // 提取 content 标签 range
        let contentTagMatchResults = contentTagRegex.matches(in: metaTag, options: [], range: NSRange(location: 0, length: metaTag.count))
        guard let firstContentTagMatchResult = contentTagMatchResults.first, let contentTagRange = Range(firstContentTagMatchResult.range(at: 1), in: metaTag) else {
          return nil
        }
        
        let property = String(metaTag[propertyTagRange])
        let content = String(metaTag[contentTagRange])
        
        return (property: property, content: content)
      }()
      
      if let openGraphResult = openGraphResult, let openGraphMetadata = VMOpenGraphMetadata(rawValue: openGraphResult.property) {
        copiedAttributes[openGraphMetadata] = openGraphResult.content
      }
      
      return copiedAttributes
    }
    
    return parserResults
  }
}

struct VMDefaultOpenGraphParser: VMOpenGraphParser {
  
}

#endif
