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
    var questionsAsked = 0
    var capitalized = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
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
        score = 0
        questionsAsked = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
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
        
        if questionsAsked == 10 && questionsAsked > 0 {
            let ad = UIAlertController(title: title, message: "Game over! \nYour final score is \(score).", preferredStyle: .alert)
            ad.addAction(UIAlertAction(title: "OK", style: .default, handler: gameOver))
            present(ad, animated: true)
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
}
