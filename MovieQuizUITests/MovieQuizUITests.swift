import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false

    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"].label
        XCTAssertEqual(indexLabel, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"].label
        XCTAssertEqual(indexLabel, "2/10")
    }
    
    func testAlertAppear() {
        sleep(5)
        for _ in 1...10{
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        sleep(2)
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testGameRestart() {
        sleep(5)
        for _ in 1...10{
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(app.staticTexts["Index"].label, "1/10")
    }
}
