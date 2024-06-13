import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(record: GameRecord) -> Bool {
        correct > record.correct
    }
}
