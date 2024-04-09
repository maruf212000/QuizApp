//
//  QuizService.swift
//  QuizApp
//
//  Created by Maruf Memon on 08/04/24.
//

import Foundation
import Combine

class QuizService: NSObject {
    static let shared = QuizService()
    static let quizUrl = "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple"
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchQuestions() -> Future<[Question], Error> {
        return Future<[Question], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(APIError.unknown))
            }
            APIService.shared.fetch(endpoint: QuizService.quizUrl, type: QuizResponse.self)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { data in
                    promise(.success(data.results))
                })
                .store(in: &self.cancellables)
        }
    }
}

