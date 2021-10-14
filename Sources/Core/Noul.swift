//
//  Noul.swift
//  Noul
//
//  Created by max on 2021/10/14.
//

#if canImport(Foundation)

import Foundation

public enum VMOpenGraphError: Error {
  case incompleteContext
  case unknown
  case unexpectedStatusCode(Int)
  case encodingError
}

#endif
