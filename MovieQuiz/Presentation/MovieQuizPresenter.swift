import UIKit

final class MovieQuizPresenter {
    
    //MARK: - Properties
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 1
    
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
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return questionStep
    }
}
