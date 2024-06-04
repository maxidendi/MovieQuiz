//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Денис Максимов on 17.05.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let complition: () -> Void
}
