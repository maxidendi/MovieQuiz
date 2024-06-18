import UIKit

struct AlertResult {
    let title: String
    let message: String
    let buttonRestart: String
    let buttonReset: String
    let complitionRestart: () -> Void
    let complitionReset: () -> Void
}

struct AlertError {
    let title: String
    let message: String
    let buttonText: String
    let complition: () -> Void
}
