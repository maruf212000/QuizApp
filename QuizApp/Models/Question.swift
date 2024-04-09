//
//  Question.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import Foundation

class QuizResponse: Codable {
    let responseCode: Int
    let results: [Question]
    
    enum CodingKeys: String, CodingKey {
        case results
        case responseCode = "response_code"
    }
}

class Question: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
