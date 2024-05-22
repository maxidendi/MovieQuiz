//
//  ClearStat + Extension.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 21.05.2024.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case correct, total, bestGame, gamesCount
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
