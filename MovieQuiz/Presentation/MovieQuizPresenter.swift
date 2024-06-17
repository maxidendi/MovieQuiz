import UIKit

final class MovieQuizPresenter {
    
    //MARK: - Properties
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 1
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    //MARK: - Methods
    
    func isLastQuestion() -> Bool {
        questionsAmount == currentQuestionIndex
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
        viewController?.showAnswerResult(isCorrect: true == actualAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
        viewController?.showAnswerResult(isCorrect: false == actualAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return questionStep
    }
}
