import UIKit

final class AlertPresenter {

    //MARK: - Properties
    
    static var shared: AlertPresenter = AlertPresenter()
    
    init() {}
    
    //MARK: - Methods
    
    func showResult(alertModel: AlertResult, view: UIViewController) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let actionRestart = UIAlertAction(
            title: alertModel.buttonRestart,
            style: .default) { _ in alertModel.complitionRestart()}
        let actionReset = UIAlertAction(
            title: alertModel.buttonReset,
            style: .default) { _ in alertModel.complitionReset()}
        
        alert.addAction(actionRestart)
        alert.addAction(actionReset)

        view.present(alert, animated: true, completion: nil)
    }
    
    func showError(alertModel: AlertError, view: UIViewController) {
        
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

                    

