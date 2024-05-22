//
//  MovieQuizViewControllerDelegate.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerDelegate: AnyObject {
    func showResult(alertModel: AlertModel) 
}
