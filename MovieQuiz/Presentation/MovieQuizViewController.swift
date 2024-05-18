import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, QuestionFactoryDelegate {
    
    // MARK: - IB Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    //MARK: - Private variables
    
    private var currentQuestionIndex: Int = 1
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertDelegate: MovieQuizViewControllerDelegate?
    
    //MARK: - Overrides of Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        noButton.isExclusiveTouch = true
        yesButton.isExclusiveTouch = true
        
        let alertDelegate = AlertPresenter()
        alertDelegate.movieQuiz = self
        self.alertDelegate = alertDelegate
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        self.questionFactory?.requestNextQuestion()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async {[weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: true == actualAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
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
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else {return}
            self.showNextQuestionOrResult()
            
            // Снова включил кнопки
            
            self.changeButtonState(isEnabled: true)
        }
    }
    
    func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть еще раз",
            complition: {[weak self] _ in
                self?.currentQuestionIndex = 1
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
            alertDelegate?.showResult(alertModel: alertModel)
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
                    
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
