//
//  APIService.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import Combine
import Foundation

class APIService: NSObject {
    static let shared = APIService()
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetch<T: Decodable>(endpoint: String, id: Int? = nil, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endpoint) else {
                return promise(.failure(APIError.badURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw APIError.badResponse
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as APIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(APIError.unknown))
                        }
                    }
                }, receiveValue: { data in
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
    }
}
