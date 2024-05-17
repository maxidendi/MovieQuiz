//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
