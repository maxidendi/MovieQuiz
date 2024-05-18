//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import Foundation
import UIKit

class AlertPresenter: MovieQuizViewControllerDelegate {
    
    weak var movieQuiz: MovieQuizViewControllerProtocol?
    
    func showResult(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.complition)
        
        alert.addAction(action)
        
        self.movieQuiz?.present(alert, animated: true, completion: nil)
    }
}

                    

