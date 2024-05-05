import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    //MARK: - Private variables
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    //MARK: - Private Struct's
    
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    //MARK: - Overrides of Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    //MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let actualAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: true == actualAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let actualAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: false == actualAnswer)
    }

    //MARK: - Private methods

    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
		noButton.isEnabled = isEnabled
	}
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // Отключил кнопки, так как при нажатии во время ожидания
        // загрузки следующего вопроса они сразу засчитывают ответ
        // Это почему то не учтено в спринте

        changeButtonState(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
            
            // Снова включил кнопки
            
            self.changeButtonState(isEnabled: true)
        }
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default) {_ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                let newQuiz = self.convert(model: self.questions[self.currentQuestionIndex])
            self.show(quiz: newQuiz)}
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            let quizResult = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/10",
                buttonText: "Сыграть еще раз")
            show(quiz: quizResult)
            } else {
                currentQuestionIndex += 1
                let nextQuestion = questions[currentQuestionIndex]
                let viewModel = convert(model: nextQuestion)
                show(quiz: viewModel)
        }
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
