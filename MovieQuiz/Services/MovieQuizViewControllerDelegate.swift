import UIKit

protocol MovieQuizViewControllerDelegate: AnyObject {
    func showResult(alertModel: AlertModel, view: UIViewController) 
}
