import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    private let alertPresenter = AlertPresenter.shared
    
    //MARK: - Overrides of Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        noButton.isExclusiveTouch = true
        yesButton.isExclusiveTouch = true
                
        presenter = MovieQuizPresenter(viewController: self)
        
        //для обнуления статистики
        //UserDefaults.standard.reset()
    }

    //MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    //MARK: - Methods
    
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showAlert(model: AlertModel) {
        alertPresenter.showResult(alertModel: model, view: self)
    }

    func showNetworkError(message: String, errorCompletion: @escaping () -> Void) {
        hideLoadingIndicator()
        let alertError = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова",
            complition: errorCompletion)
        showAlert(model: alertError)
    }
    
    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        changeButtonState(isEnabled: true)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        changeButtonState(isEnabled: false)
    }
}
