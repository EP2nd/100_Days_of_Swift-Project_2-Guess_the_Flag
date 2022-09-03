import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var highestScore = 0
    var questionsAsked = 0
    var capitalized = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        let defaults = UserDefaults.standard
        
        if let savedHighestScore = defaults.object(forKey: "highestScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highestScore = try jsonDecoder.decode(Int.self, from: savedHighestScore)
            } catch {
                print("Failed to load the highest score.")
            }
        }
        
        // Alternative way (the foregoing was for custom types):
        
        /* let defaults = UserDefaults.standard
         
        if let highestScore = defaults.value(forKey: "highestScore") as? Int {
            self.highestScore = highestScore
        } else {
            print("Failed to load the highest score.")
        } */
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    @objc func showScore() {
        let info = "Score: \(score)"
        
        let viewScore = UIActivityViewController (activityItems: [info], applicationActivities: [])
        viewScore.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewScore, animated: true)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        if countries[correctAnswer].count <= 3 {
            capitalized = (countries[correctAnswer].uppercased())
        } else {
            capitalized = countries[correctAnswer].capitalizingFirstLetter()
        }
        
        /* title = "\(capitalized) (Score: \(score))" */
        title = "\(capitalized)"
    }
    
    func gameOver(action: UIAlertAction! = nil) {
        save()
        
        score = 0
        questionsAsked = 0
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
        // Project_15-Challenge_3:
        if sender == button1 {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.button1.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.button1.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else if sender == button2 {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.button2.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.button2.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else if sender == button3 {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.button3.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.button3.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
            questionsAsked += 1
        } else if countries[sender.tag].count <= 3 {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
            questionsAsked += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].capitalizingFirstLetter())."
            score -= 1
            questionsAsked += 1
        }
        
        if questionsAsked == 10 && score > highestScore {
            let ac = UIAlertController(title: "Game over!", message: "You set a new record! Your final score: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: gameOver))
            present(ac, animated: true)
            
            highestScore = score
        } else if questionsAsked == 10 && score <= highestScore {
            let ac = UIAlertController(title: "Game over!", message: "Your final score: \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: gameOver))
            present(ac, animated: true)
        }
        
        let ac = UIAlertController(title: title, message: "Your current score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedHighestScore = try? jsonEncoder.encode(highestScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedHighestScore, forKey: "highestScore")
        } else {
            print("Failed to save the highest score.")
        }
    }
    
    // Alternative function (the foregoing was for custom types):
    
    /* func save() {
        let defaults = UserDefaults.standard
        
        do {
            defaults.set(highestScore, forKey: "highestScore")
            print("Failed to save the highest score.")
        }
    } */
}
