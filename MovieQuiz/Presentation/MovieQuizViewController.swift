import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, QuestionFactoryDelegate {
    
    // MARK: - IB Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var correctAnswers: Int = 0
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertDelegate: MovieQuizViewControllerDelegate?
    private var statisticService: StatisticService?
    
    //MARK: - Overrides of Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        noButton.isExclusiveTouch = true
        yesButton.isExclusiveTouch = true
        
        let alertDelegate = AlertPresenter()
        alertDelegate.viewController = self
        self.alertDelegate = alertDelegate
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        questionFactory.movieLoader = MoviesLoader()
        self.questionFactory = questionFactory
        
        presenter.viewController = self
        
        statisticService = StatisticServiceImplementation()
        
        activityIndicator.startAnimating()
        self.questionFactory?.loadData()
        
        //для обнуления статистики
        //UserDefaults.standard.reset()
    }
    
    //MARK: - QuestionFactoryDelegates
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        self.show(quiz: viewModel)

    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let completion = {[weak self] in
            guard let self else { return }
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.activityIndicator.startAnimating()
            self.questionFactory?.loadData()
        }
        guard let error = error as? NetworkErrors else {
            return showNetworkError(
                message: error.localizedDescription,
                errorCompletion: completion)
        }
        switch error {
        case .codeError, .invalidUrlError(_):
            showNetworkError(
                message: error.localizedDescription,
                errorCompletion: completion)
        case .loadImageError(_):
            showNetworkError(
                message: error.localizedDescription)
            {[weak self] in self?.questionFactory?.requestNextQuestion()}
        }
        
    }
    
    //MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
//        guard let currentQuestion else {
//            return
//        }
//        let actualAnswer = currentQuestion.correctAnswer
//        showAnswerResult(isCorrect: true == actualAnswer)
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
//        guard let currentQuestion else {
//            return
//        }
//        let actualAnswer = currentQuestion.correctAnswer
//        showAnswerResult(isCorrect: false == actualAnswer)
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }

    //MARK: - Methods
    
    private func showNetworkError(message: String, errorCompletion: @escaping () -> Void) {
        activityIndicator.stopAnimating()
        
        let alertError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова",
            complition: errorCompletion)
        alertDelegate?.showResult(alertModel: alertError)
    }

    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
		noButton.isEnabled = isEnabled
	}

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        changeButtonState(isEnabled: true)
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        changeButtonState(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else { return }
            self.showNextQuestionOrResult()
        }
    }
    
    func showNextQuestionOrResult() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text =
                    """
                    Ваше результат: \(correctAnswers)/\(presenter.questionsAmount)
                    Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
                    Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? ""))
                    Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
                    """
            let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть еще раз",
            complition: {[weak self] in
                guard let self else { return }
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
            alertDelegate?.showResult(alertModel: alertModel)
            } else {
                presenter.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
                    
        }
    }
}

