import UIKit

final class AlertPresenter: MovieQuizViewControllerDelegate {

    //MARK: - Properties
    
    static var shared: AlertPresenter = AlertPresenter()
    
    init() {}
    
    //MARK: - Methods
    
    func showResult(alertModel: AlertModel, view: UIViewController) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in alertModel.complition()}
        
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
}

                    

