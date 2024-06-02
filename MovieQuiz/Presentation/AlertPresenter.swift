//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import UIKit

class AlertPresenter: MovieQuizViewControllerDelegate {

    //MARK: - Properties

    weak var viewController: MovieQuizViewControllerProtocol?
    
    //MARK: - Methods
    
    func showResult(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in alertModel.complition()}
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}

                    

