//
//  JSONStringUtilities.swift
//  Venko
//
//  Created by Matias Glessi on 24/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import Alamofire

enum StringifyError: Error {
  case isNotValidJSONObject
}

struct JSONStringify {
  
  let value: Any
  
  func stringify(prettyPrinted: Bool = false) throws -> String {
    let options: JSONSerialization.WritingOptions = prettyPrinted ? .prettyPrinted : .init(rawValue: 0)
    if JSONSerialization.isValidJSONObject(self.value) {
      let data = try JSONSerialization.data(withJSONObject: self.value, options: options)
      if let string = String(data: data, encoding: .utf8) {
        return string
        
      }
    }
    throw StringifyError.isNotValidJSONObject
  }
}
protocol Stringifiable {
  func stringify(prettyPrinted: Bool) throws -> String
}

extension Stringifiable {
  func stringify(prettyPrinted: Bool = false) throws -> String {
    return try JSONStringify(value: self).stringify(prettyPrinted: prettyPrinted)
  }
}

extension Dictionary: Stringifiable {}
extension Array: Stringifiable {}

struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String

    init(string: String) {
        self.myString = string
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest

        let data = myString.data(using: .utf8)!

        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest?.httpBody = data

        return urlRequest!
    }
}
