//
//  NetworkResponseModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 19/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct NetworkResponseModel {
    var statusCode: Int
    var successTitle = "Success"
    var generalMessage: String?
    var data: Any?
    var success = false
    var headers = [String: String]()
    var error: Error?
    var errorTitle = "Error"
    
    init() {
        self.statusCode = 0
    }
    
    init(statusCode: Int) {
        self.statusCode = statusCode
    }
    
    init(error: Error) {
        self.error = error
        self.statusCode = 0
    }
    
    init(statusCode: Int, error: Error, data: JSON) {
        self.error = error
        self.data = data
        self.statusCode = statusCode
    }
    
    init(statusCode: Int, error: Error) {
        self.error = error
        self.statusCode = statusCode
    }
    
    func getErrorMessage() -> String {
        var msg: String = ""
        if let data = data as? JSON {
            let message = data["error"]["message"]
            for (_, value) in message {
                let val = value.description
                let badchar = CharacterSet(charactersIn: "\"[]")
                msg += val.components(separatedBy: badchar).joined()+"\n"
            }
        }else if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                msg = "Invalid URL"
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                msg = "Parameter encoding failed"
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                 msg = "Multipart encoding failed"
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                msg = "Response validation failed"
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                msg = "Response serialization failed"
                print("Failure Reason: \(reason)")
            }
        }else if let error = error as? URLError {
            switch(error.errorCode){
            case NSURLErrorTimedOut:
                msg = "Time out error"
                break
            case NSURLErrorNotConnectedToInternet:
                msg = "Error, please check your internet connection"
                break
            case NSURLErrorBadURL:
                msg = "Error, Bad URL"
                break
            case NSURLErrorCancelled:
                msg = "Request cancelled"
                break
            case NSURLErrorSecureConnectionFailed:
                msg = "Failed to get a secure connection"
                break
            case NSURLErrorServerCertificateUntrusted:
                msg = "The server certification is untrusted"
                break
            case NSURLErrorCannotLoadFromNetwork:
                msg = "Cannot load from network"
                break
            default:
                msg = "Network Error"
            }
            print("The error\(msg)")
        }else{
            msg = error?.localizedDescription ?? "Unknown Error, Please Try Again"
        }
        return msg
    }
    
}

struct ArrayResponseModel {
    var page: Int
    var size: Int
    var count: Int
    var data: [Any]
    
    init(page: Int, size: Int, count: Int, data: [Any]) {
        self.page = page
        self.size = size
        self.count = count
        self.data = data
    }
}
