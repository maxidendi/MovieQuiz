//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 20.05.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(record: GameRecord) -> Bool {
        correct > record.correct
    }
}
