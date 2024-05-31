//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 20.05.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            return Double(100) * Double(correct) / Double(total)
        }
    }

    var gamesCount: Int {
        get {
            let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return gamesCount
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            return
        }
        
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            return userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        
        var correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        var total = userDefaults.integer(forKey: Keys.total.rawValue)
        
        correct += count
        total += amount
            
        userDefaults.set(correct, forKey: Keys.correct.rawValue)
        userDefaults.set(total, forKey: Keys.total.rawValue)
        
        gamesCount += 1
        
        if newGame.isBetterThan(record: bestGame) {
            bestGame = newGame
        }
       
    }
}
