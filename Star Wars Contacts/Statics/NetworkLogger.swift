//
//  NetworkLogger.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/18/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLogger: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        print("Network Request: \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let urlRequest = request.request
        print("Network Response: \(urlRequest?.httpMethod ?? "") \(urlRequest?.url?.absoluteString ?? "")")
        completion(.doNotRetry)
    }
}
