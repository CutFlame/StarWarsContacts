//
//  DirectoryService.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import enum Alamofire.AFError
import class Alamofire.Session
import struct Alamofire.DataResponse

typealias ResultHandler<T> = (Result<T, Error>) -> ()

typealias DirectoryResult = Result<[IndividualModel], Error>
typealias DirectoryResultHandler = ResultHandler<[IndividualModel]>
typealias DataResultHandler = ResultHandler<Data>

protocol DirectoryServiceProtocol {
    func fetchDirectory(_ handler: @escaping DirectoryResultHandler)
    func fetchData(_ url: URL, _ handler: @escaping DataResultHandler)
}

class DirectoryService: DirectoryServiceProtocol {
    private let session: Session
    init(resolver: DependencyResolver = DependencyContainer.resolver) {
        self.session = resolver.resolve()
    }
    
    func fetchDirectory(_ handler: @escaping DirectoryResultHandler) {
        let directoryURL = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        session.request(directoryURL)
            .responseData { [weak self] response in
                let urlRequest = response.request
                print("Network Response: \(urlRequest?.httpMethod ?? "") \(urlRequest?.url?.absoluteString ?? "")")
                
                self?.handleDirectoryResponse(response, handler)
        }
    }

    func handleDirectoryResponse(_ response:DataResponse<Data, AFError>, _ handler: DirectoryResultHandler) {
        switch response.result {
        case .success(let data):
            do {
                let wrapper = try ResponseWrapper(data: data)
                handler(.success(wrapper.individuals))
            }
            catch {
                handler(.failure(error))
            }
        case .failure(let error):
            handler(.failure(error))
        }
    }

    func fetchData(_ url: URL, _ handler: @escaping DataResultHandler) {
        session.request(url)
            .responseData { response in
                let urlRequest = response.request
                print("Network Response: \(urlRequest?.httpMethod ?? "") \(urlRequest?.url?.absoluteString ?? "")")
                // why do I have to do this?  AFError is an error.  Weird...
                let theResult: Result<Data, Error>
                switch response.result {
                case .failure(let err):
                    theResult = .failure(err)
                case .success(let data):
                    theResult = .success(data)
                }
                
                handler(theResult)
        }
    }
}

