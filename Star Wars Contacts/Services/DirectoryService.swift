//
//  DirectoryService.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
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

class DirectoryService {
    private let sessionManager = Alamofire.Session()

    func fetchDirectory(_ handler: @escaping DirectoryResultHandler) {
        let directoryURL = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        sessionManager.request(directoryURL)
            .responseData { [weak self] response in
                self?.handleDirectoryResponse(response, handler)
        }
    }

    func handleDirectoryResponse(_ response:DataResponse<Data>, _ handler: DirectoryResultHandler) {
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
        sessionManager.request(url)
            .responseData { response in
                handler(response.result)
        }
    }
}

