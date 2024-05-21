import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, QuestionFactoryDelegate {
    
    // MARK: - IB Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    //MARK: - Private variables
    
    private var currentQuestionIndex: Int = 1
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertDelegate: MovieQuizViewControllerDelegate?
    private var statisticService: StatisticService?
    
    //MARK: - Overrides of Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        noButton.isExclusiveTouch = true
        yesButton.isExclusiveTouch = true
        
        let alertDelegate = AlertPresenter()
        alertDelegate.movieQuiz = self
        self.alertDelegate = alertDelegate
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        self.questionFactory?.requestNextQuestion()
        
        statisticService = StatisticServiceImplementation()
        
        //для обнуления статистики
        //UserDefaults.standard.reset()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async {[weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: true == actualAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        let actualAnswer = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: false == actualAnswer)
    }

    //MARK: - Private methods

    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
		noButton.isEnabled = isEnabled
	}
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        changeButtonState(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else {
                return
            }
            self.showNextQuestionOrResult()
            self.changeButtonState(isEnabled: true)
        }
    }
    
    func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let text =
                    """
                    Ваше результат: \(correctAnswers)/10
                    Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
                    Рекорд: \(statisticService?.bestGame.correct ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? ""))
                    Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
                    """
            let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть еще раз",
            complition: {[weak self] _ in
                self?.currentQuestionIndex = 1
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
            alertDelegate?.showResult(alertModel: alertModel)
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
                    
        }
    }
}








/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/


/*
var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let moviesTop = "top250MoviesIMDB.json"
documentsURL.appendPathComponent(moviesTop)
let string = try? String(contentsOf: documentsURL)
guard let data = string?.data(using: .utf8) else {
    return
}

let result = try? JSONDecoder().decode(Top.self, from: data)
print(result ?? "")


//FileManager Task

var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
print(documentsURL)
let fileName = "text.swift"

documentsURL.appendPathComponent(fileName)
print(documentsURL)

print(FileManager.default.fileExists(atPath: documentsURL.path))
if !FileManager.default.fileExists(atPath: documentsURL.path) {
    let hello = "Hello World! How are you?"
    let data = hello.data(using: .utf8)
    FileManager.default.createFile(atPath: documentsURL.path, contents: data)
}
print(FileManager.default.fileExists(atPath: documentsURL.path))
try? print(String(contentsOf: documentsURL))
try? FileManager.default.removeItem(at: documentsURL)

//Error HandLing

enum FileManagerError: Error {
    case fileDoesntExist
}
func string(from documentsURL: URL) throws -> String {
    if !FileManager.default.fileExists(atPath: documentsURL.path) {
        throw FileManagerError.fileDoesntExist
    }
    return try String(contentsOf: documentsURL)
}

var str = ""

do {
    try print(str = string(from: documentsURL))
} catch FileManagerError.fileDoesntExist {
    print("Файл по адресу \(documentsURL.path) не существует")
} catch {
    print("Неизвестная ошибка чтения из файла \(error)")
}

//JSON

var jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let jsonName = "inception.json"
jsonURL.appendPathComponent(jsonName)
let jsonString = try? String(contentsOf: jsonURL)

guard let data = jsonString?.data(using: .utf8) else {
    return
}
do {
    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    print("Failed to parse: \(error)")
}

func getMovie(form jsonString: String) -> Movie? {
    var movie: Movie? = nil
    
    do {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        let jsonMovie = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let jsonMovie = jsonMovie,
              let id = jsonMovie["id"] as? String,
              let title = jsonMovie["title"] as? String,
              let year = jsonMovie["year"] as? Int,
              let image = jsonMovie["image"] as? String,
              let releaseDate = jsonMovie["releaseDate"] as? String,
              let runtime = jsonMovie["runtime"] as? Int,
              let directors = jsonMovie["directors"] as? String,
              let actorList = jsonMovie["actorList"] as? [Any]
        else {
            return nil
        }
        var actors: [Actor] = []
        
        for actor in actorList {
            guard let actor = actor as? [String: Any],
                  let id = actor["id"] as? String,
                  let image = actor["image"] as? String,
                  let name = actor["name"] as? String,
                  let asCharacter = actor["asCharacter"] as? String else {
                return nil
            }
            let mainActor = Actor(id: id,
                                  image: image,
                                  name: name,
                                  asCharacter: asCharacter)
            actors.append(mainActor)
        }
        movie = Movie(id: id,
                      title: title,
                      year: year,
                      image: image,
                      releaseDate: releaseDate,
                      runtimeMin: runtime,
                      directors: directors,
                      actorList: actors)
    } catch {
        print("Some error: \(error)")
    }
    return movie
}

do {
    let movie = try JSONDecoder().decode(Movie.self, from: data)
} catch {
    print("Failed to parse: \(error)")
}
 */

