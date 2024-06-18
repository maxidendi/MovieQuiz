import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    //MARK: - Properties
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 1
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticServiceProtocol
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController?) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(
            movieLoader: MoviesLoader(), 
            imageLoader: ImageLoader(),
            delegate: self)
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        viewController?.hideLoadingIndicator()
        viewController?.show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let completion = {[weak self] in
            guard let self else { return }
            self.resetQuestionIndex()
            self.correctAnswers = 0
            self.viewController?.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        guard let error = error as? NetworkErrors else {
            showNetworkError(
                message: error.localizedDescription,
                errorCompletion: completion)
            return
        }
        switch error {
        case .codeError, .invalidUrlError(_):
            showNetworkError(
                message: error.localizedDescription,
                errorCompletion: completion)
        case .loadImageError(_):
            showNetworkError(
                message: error.localizedDescription) {[weak self] in
                self?.viewController?.showLoadingIndicator()
                self?.questionFactory?.requestNextQuestion()
            }
        }
        
    }
    
    //MARK: - Methods
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    private func isLastQuestion() -> Bool {
        questionsAmount == currentQuestionIndex
    }
    private func resetQuestionIndex() {
        currentQuestionIndex = 1
    }
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return questionStep
    }
    
    private func showNetworkError(message: String, errorCompletion: @escaping () -> Void) {
        viewController?.hideLoadingIndicator()
        let alertError = AlertError(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова",
            complition: errorCompletion)
        viewController?.showError(model: alertError)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else { return }
            self.viewController?.showLoadingIndicator()
            self.proceedNextQuestionOrResult()
        }
    }
    
    private func proceedNextQuestionOrResult() {
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let text =
                    """
                    Ваше результат: \(correctAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """
            let completionRestart = {[weak self] in
                guard let self else { return }
                self.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()}
            let alertResult = AlertResult(
            title: "Этот раунд окончен!",
            message: text,
            buttonRestart: "Сыграть еще раз",
            buttonReset: "Сброс статистики",
            complitionRestart: completionRestart,
            complitionReset: {
                completionRestart()
                UserDefaults.standard.reset()})
            viewController?.showResult(model: alertResult)
            } else {
                switchToNextQuestion()
                questionFactory?.requestNextQuestion()
        }
    }
}
