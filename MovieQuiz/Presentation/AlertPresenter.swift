//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import UIKit

class AlertPresenter: MovieQuizViewControllerDelegate {
    
    weak var viewController: MovieQuizViewControllerProtocol?
    
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

                    

