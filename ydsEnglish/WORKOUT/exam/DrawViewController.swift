//
//  DrawViewController.swift
//  DaysTableView
//
//  Created by çağrı on 16.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import FirebaseDatabase

struct Question {
   var question : String
   var answerA : String
    var answerB : String
    var answerC : String
    var answerD : String
    var answerE : String
    var correctAnswer : Int
    var type : QuestionTypes
    
}

enum QuestionTypes : String, Codable {
    case word
    case clozeTest
    case sentenceCompleting
    case translation
    case paragraph
    case dialogue
    case closeMeaning
    case paragraphCompletion
    case wrongMeaning
}

struct TrackTypeAnswer : Codable {
    var type : QuestionTypes
    var right : Int
    var wrong : Int
}

var trackedTypes = [TrackTypeAnswer]()

let  examDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!



struct AnsweredQuestion : Codable{
    var correctAnswer : Int
    var givenAnswer : Int
    var questionNum : Int
}
protocol ProgressedInt {
    var progressInt : Int { get set }
    var examNum : Int { get set }
}


 let trackTypeURL = examDirectory.appendingPathComponent("trackType").appendingPathExtension("plist")

// class starts here dont consider above inside this class they are just global variables

class DrawViewController: UIViewController {
    
    
    @IBOutlet weak var qNumLabel: UILabel!
    
    
     let questionTextView = UITextView()
    let label = UILabel()
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let label4 = UILabel()
    let answerLabel = UILabel()
    let answerLabel1 = UILabel()
    let answerLabel2 = UILabel()
    let answerLabel3 = UILabel()
    let answerLabel4 = UILabel()
    
    @IBOutlet weak var pointLabel: UILabel!
    
    
    var delegate : ProgressedInt?
    
    var ref : DatabaseReference?
    @IBOutlet weak var exitButton: UIButton!
    
    @IBAction func goBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    let key = "trnsl.1.1.20190423T111402Z.a5390bf10bf7f97e.434f4a43aafb25f10818db82c63ec0680f83ade1"
    
    let url = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    
    
    
    var questions = [Question]()
    
    var answeredQuestions = [AnsweredQuestion]()
    
    var examNum : Int?
    
   let layer = CAShapeLayer()
    
    let shapeLayer = CAShapeLayer()
    
    var labels = [UILabel]()
    
    var examURL : URL?
   
    
    var translatedWord : String?
    var importantWords = [String]()
    let popUpView = UIView()
    let labelEnglish = UILabel()
    let labelTurkish = UILabel()
    var firstRect = CGRect()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
     pointLabel.isHidden = true
 
        examURL = examDirectory.appendingPathComponent("exam\(examNum!)").appendingPathExtension("plist")
        
       
       
      
       getAnswersFromLocalData()
    
        self.delegate?.examNum = examNum!
        self.delegate?.progressInt = index
        
     
             index = userDefaults.integer(forKey: "q\(examNum!)")
        
        
        
         qNumLabel.text = "Question\(index + 1)"
        
        labels.append(label)
        labels.append(label1)
        labels.append(label2)
        labels.append(label3)
        labels.append(label4)
        
        for l in labels {
            l.clipsToBounds = true
        }
        
        ref = Database.database().reference()
        

        
        ref!.child("Exams").child("exam\(examNum! + 1)").observe(.value, with: { (snap) in
          
            let count = snap.childrenCount
            
            for i in 0..<count {
             
                
                if let question = snap.childSnapshot(forPath: "\(i + 1)").value as? [String : Any] {
                    let type : QuestionTypes = QuestionTypes(rawValue: question["type"] as? String ?? "") ?? QuestionTypes(rawValue: "word")!
                    
                  
                    
                   
                    
                   
                    
                    self.questions.append(Question(question: question["question"] as? String ?? "", answerA: question["answerA"] as? String ?? "", answerB: question["answerB"] as? String ?? "", answerC: question["answerC"] as? String ?? "", answerD: question["answerD"] as? String ?? "", answerE: question["answerE"] as? String ?? "", correctAnswer: question["correctAnswer"] as? Int ?? 0, type: type))
                    
                    
                    
                }
                
            }
            
            self.questionTextView.text = self.questions[self.index].question
            self.answerLabel.text = self.questions[self.index].answerA
            self.answerLabel1.text = self.questions[self.index].answerB
            self.answerLabel2.text = self.questions[self.index].answerC
            self.answerLabel3.text = self.questions[self.index].answerD
            self.answerLabel4.text = self.questions[self.index].answerE
            
          
            
            
            self.reloadOldAnswers()
           
            
        })
        
       let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 100))
        path.addCurve(to: CGPoint(x: 300, y: 100), controlPoint1: CGPoint(x: 100, y: 50), controlPoint2: CGPoint(x: 200, y : 150))
        path.lineWidth = 5
        path.addClip()
        
        
        shapeLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 500, height: 500)).cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.frame = self.view.bounds
        
        
        questionTextView.isEditable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(getPoint))
        questionTextView.addGestureRecognizer(tap)
        questionTextView.isUserInteractionEnabled = true
        
       layer.path = path.cgPath
        layer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.lineWidth = 10
        
        
        
        view.backgroundColor = UIColor(displayP3Red: 227/255, green: 135/255, blue: 60/255, alpha: 1)
        
 
        exitButton.setTitleColor(UIColor.white, for: .normal)
        exitButton.backgroundColor = UIColor.clear
        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerSegue" {
            let vc = segue.destination as! AnswersViewController
            vc.examURL = examURL
            vc.answeredQuestions = answeredQuestions
            
            
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let button = KCFloatingActionButton(frame: CGRect(x: view.frame.width/2 - 20, y: topView.frame.maxY + 10, width: 30, height: 30))
        button.plusColor = view.backgroundColor!
        button.itemShadowColor = view.backgroundColor!
       
        
        
        button.addItem(title: "Cevap Anhtarı") { (item) in
          self.performSegue(withIdentifier: "answerSegue", sender: Any.self)
            button.close()
        }
        
        button.addItem(title: "Sınavı Sıfırla") { (item) in
            
            self.answeredQuestions = []
            self.writeAnswersToLocalData()
            userDefaults.setValue(0, forKey: "q\(self.examNum!)")
            
            
            
        }
        
        
        
        
        button.buttonColor = UIColor.white
    
        
        button.openAnimationType = .fade
        
       
        
       
        questionTextView.frame = CGRect(x: 0 , y: 0, width: topView.frame.width, height: topView.frame.height/2.5)
      
        
        
 
        
        questionTextView.textColor = UIColor.darkText
        questionTextView.font = UIFont(name: "Futura", size: 20 )
        questionTextView.backgroundColor = UIColor.clear
       
        
        
       answerLabelsFrame(letterLabel: label, answerLabel: answerLabel, num: 0)
         answerLabelsFrame(letterLabel: label1, answerLabel: answerLabel1, num: 1)
         answerLabelsFrame(letterLabel: label2, answerLabel: answerLabel2, num: 2)
         answerLabelsFrame(letterLabel: label3, answerLabel: answerLabel3, num: 3)
         answerLabelsFrame(letterLabel: label4, answerLabel: answerLabel4, num: 4)
        
        
        nextButton.backgroundColor = UIColor.white
        nextButton.setTitleColor(self.view.backgroundColor, for: .normal)
        nextButton.layer.cornerRadius = 15
        
        backButton.backgroundColor = UIColor.white
        backButton.setTitleColor(self.view.backgroundColor, for: .normal)
        backButton.layer.cornerRadius = 15
    
        
        self.view.addSubview(button)
        topView.addSubview(questionTextView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectOption))
          let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectOption1))
          let tap2 = UITapGestureRecognizer(target: self, action: #selector(selectOption2))
         let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectOption3))
          let tap4 = UITapGestureRecognizer(target: self, action: #selector(selectOption4))
        
       answerLabel.isUserInteractionEnabled = true
        answerLabel1.isUserInteractionEnabled = true
        answerLabel2.isUserInteractionEnabled = true
        answerLabel3.isUserInteractionEnabled = true
        answerLabel4.isUserInteractionEnabled = true
        
        for label in labels {
            label.isUserInteractionEnabled =  true
        }
        
        labels[0].addGestureRecognizer(tap)
        labels[1].addGestureRecognizer(tap1)
        labels[2].addGestureRecognizer(tap2)
        labels[3].addGestureRecognizer(tap3)
        labels[4].addGestureRecognizer(tap4)
        
        
    

     questionTextView.textAlignment = .left
        
         popUpTranslationView()
        
        
    }
    
    @objc func selectOption() {
        
 selectAnswer(label: label)
        
    }
    @objc func selectOption1() {
     selectAnswer(label: label1)
        
    }
    @objc func selectOption2() {
   selectAnswer(label: label2)
        
        
        
    }
    @objc func selectOption3() {
    selectAnswer(label: label3)
        
    }
    @objc func selectOption4() {
        
     selectAnswer(label: label4)
        
    }
    
    

    
    
    
    var index = 0
    
    func reloadOldAnswers() {
        
        
        for l in labels {
            l.backgroundColor = UIColor.clear
        }
        
        if let indexOfOldAnswers = answeredQuestions.firstIndex(where:{ $0.questionNum == index}) {
            
            
            
            
            labels[answeredQuestions[indexOfOldAnswers].givenAnswer].backgroundColor =  UIColor.flatGrayColorDark()
            labels[answeredQuestions[indexOfOldAnswers].correctAnswer].backgroundColor = UIColor.flatMint()
        }
    }
    
    
    
    
    @IBAction func back(_ sender: UIButton) {
        
        index -= 1
        if index < 0 {
            index = 0
            return
        }
        
        
        for l in labels {
            l.isUserInteractionEnabled = true
        }
        
        answerLabel.isHidden = false
        answerLabel1.isHidden = false
        answerLabel2.isHidden = false
        answerLabel3.isHidden = false
        answerLabel4.isHidden = false
        
        for l in labels {
            l.isHidden = false
        }
        
        if answeredQuestions.count > index {
            if answeredQuestions[index].correctAnswer == answeredQuestions[index].givenAnswer {
                
                saveAnswersForTypes(answerIsTrue: true)
            } else {
                saveAnswersForTypes(answerIsTrue: false)
            }
        }
        
        
        
        print(trackedTypes)
        
      
        
        qNumLabel.text = "Question\(index + 1)"
        
        userDefaults.setValue(index, forKey: "q\(examNum!)")
        
        
  
        
        
        
        reloadOldAnswers()
        
        self.delegate?.examNum = examNum!
        self.delegate?.progressInt = index
        
        
        UIView.transition(with: topView, duration: 1, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        questionTextView.text = questions[index].question
        answerLabel.text = questions[index].answerA
        answerLabel1.text = questions[index].answerB
        answerLabel2.text = questions[index].answerC
        answerLabel3.text = questions[index].answerD
        answerLabel4.text = questions[index].answerE
        
        
        
        
        
    }
    
    
    
    
    
    
    @IBAction func next(_ sender: UIButton) {
        
        
        for l in labels {
            l.isUserInteractionEnabled = true
            
        }
        guard index < questions.count else { return}

        if answeredQuestions.count > index {
            if answeredQuestions[index].correctAnswer == answeredQuestions[index].givenAnswer {
                
                saveAnswersForTypes(answerIsTrue: true)
            } else {
                saveAnswersForTypes(answerIsTrue: false)
            }
        } 
        
     
        
        print(trackedTypes)
        
        index += 1
        
        
        
        
        if index >= questions.count {
            questionTextView.text = """
            
            
            
            SINAV SONA ERDİ
            
            
            """
            questionTextView.font = UIFont(name: "Futura-Bold", size: 30)
            for l in labels {
                l.isHidden = true
                
            }
            answerLabel.isHidden = true
            answerLabel1.isHidden = true
            answerLabel2.isHidden = true
            answerLabel3.isHidden = true
            answerLabel4.isHidden = true
            return
        }
       
        qNumLabel.text = "Question\(index + 1)"
        
        userDefaults.setValue(index, forKey: "q\(examNum!)")
        
       reloadOldAnswers()
        
        self.delegate?.examNum = examNum!
        self.delegate?.progressInt = index
        
        
    UIView.transition(with: topView, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
        questionTextView.text = questions[index].question
        answerLabel.text = questions[index].answerA
         answerLabel1.text = questions[index].answerB
         answerLabel2.text = questions[index].answerC
         answerLabel3.text = questions[index].answerD
         answerLabel4.text = questions[index].answerE
        
        
     
        
        
    }
    
    
    
    func answerLabelsFrame(letterLabel : UILabel, answerLabel : UILabel, num : Int) {
        let letters = ["A","B","C","D","E"]
        
        
        letterLabel.layer.borderColor = UIColor.darkText.cgColor
        letterLabel.layer.borderWidth = 1
        letterLabel.layer.cornerRadius = 15
      
         letterLabel.frame = CGRect(x: 5, y: topView.frame.height*11.5/25 + (topView.frame.height*1.5 / 12.5)*CGFloat(num) - 15 , width: 30, height: 30)
        
        
        answerLabel.frame = CGRect(x: 40, y:  topView.frame.height/2.5 + (topView.frame.height*1.5 / 12.5)*CGFloat(num) , width: topView.frame.width - 40, height: (topView.frame.height*1.5/12.5))
        
        answerLabel.backgroundColor = UIColor.clear
        
        answerLabel.font = UIFont(name: "Futura", size: 20)
        answerLabel.numberOfLines = 0
        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.minimumScaleFactor = 0.5
       
        
        letterLabel.text = letters[num ]
        letterLabel.font = UIFont(name: "Futura-Bold", size: 14)
        letterLabel.textAlignment = .center
        
        topView.addSubview(letterLabel)
        topView.addSubview(answerLabel)
        
    }
    
    func selectAnswer(label: UILabel) {
        let labelIndex = labels.firstIndex(where:{$0 == label })
        for l in labels {
            l.backgroundColor = UIColor.clear
        }
        
        label.backgroundColor = UIColor.flatGrayColorDark()
        
       
        
        
        if questions[index].correctAnswer == labelIndex {
            for l in labels {
                l.backgroundColor = UIColor.clear
            }
         labels[questions[index].correctAnswer].backgroundColor = UIColor.flatMint()
            
            let points = userDefaults.integer(forKey: "points")
            
            userDefaults.set(points + 10, forKey: "points")
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                self.pointLabel.isHidden = false
                self.pointLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            }) { (true) in
                self.pointLabel.transform = .identity
                self.pointLabel.isHidden = true
            }
            
            
            
           
        } else {
            labels[questions[index].correctAnswer].backgroundColor = UIColor.flatMint()
     
        }
        
        
 
        if answeredQuestions.count > index  {
            
            answeredQuestions[index].givenAnswer = labelIndex!
            
        } else {
          answeredQuestions.append(AnsweredQuestion(correctAnswer: questions[index].correctAnswer, givenAnswer: labelIndex!, questionNum: index))
        }
     
        
        
        writeAnswersToLocalData()
    
        
        for l in labels {
            l.isUserInteractionEnabled = false
        }

    }
    
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    
    
    func saveAnswersForTypes(answerIsTrue :  Bool) {
        if let data = try? Data(contentsOf: trackTypeURL) {
            do {
                trackedTypes = try decoder.decode([TrackTypeAnswer].self, from: data)
            } catch {
                print(error)
            }
        }
        
        let currentType =  questions[index].type
        
     
           let hasThis = trackedTypes.firstIndex(where: {$0.type == currentType})
            
            if hasThis != nil {
                if answerIsTrue {
                   trackedTypes[hasThis!].right += 1
                } else {
                    trackedTypes[hasThis!].wrong += 1
                }
                
            } else {
                
                    if answerIsTrue {
                        print("hereee")
                        trackedTypes.append(TrackTypeAnswer(type: currentType, right: 1, wrong: 0))
                    } else {
                        print("or heree")
                        trackedTypes.append(TrackTypeAnswer(type: currentType, right: 0, wrong: 1))
                    }
             
                
            }
            
        
        
        do {
            let encoded = try! encoder.encode(trackedTypes)
            try! encoded.write(to: trackTypeURL)
        }
        
    
        
    }
    
    
    
    func getAnswersFromLocalData () {
        if let data = try? Data(contentsOf: examURL!) {
            do {
                answeredQuestions = try decoder.decode([AnsweredQuestion].self, from: data)
            } catch {
                print(error)
            }
        }

        
    }
    
    func writeAnswersToLocalData () {
 
        do {
            let encoded = try? encoder.encode(self.answeredQuestions)
            try? encoded?.write(to: examURL!)
     
        }

    }
    
    
    
    

}


extension DrawViewController {
    
    
    
    
    
    
    @objc func getPoint(_ tapGesture : UITapGestureRecognizer) {
        
        
        
        let point = tapGesture.location(in: questionTextView)
     
        
      
   
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
            self.popUpView.center.y = point.y + 100 + self.topView.frame.minY
        }) { (true) in
           
         
        }
        
      
        
        
        
        
        
     
        
        
        if let detectedWord = getWord(point) {

            translate(word: detectedWord)
            

            
        }
        
    }
    
    func getWord(_ point : CGPoint) -> String? {
        
        
        if let textPosition = questionTextView.closestPosition(to: point) {
            if let range = questionTextView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) {
                return questionTextView.text(in: range)
            }
        }
        
        return nil
        
    }
    
    
    func translate(word : String) {
        
        
        let session = URLSession(configuration: .default)
        var datatask : URLSessionDataTask?
        
        
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: url)
        let param = ["text":word,"key":key, "lang":"en-tr"]
        for (key,value) in param {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL?.queryItems = items
        let request =  URLRequest(url: (myURL?.url)!)
        
        datatask = session.dataTask(with: request, completionHandler: {data, response, error in
            if error == nil {
                let receivedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
             
                
              
               
                
                let a = "\(String(describing: receivedData!["text"]))"
                let all =   a.components(separatedBy: "(")
                let afterAll = all[2]
                let last = afterAll.components(separatedBy:")" )
                
                
                self.translatedWord = last[0]
                
                self.importantWords.append(last[0])
                
                let trimmedString = self.translatedWord!.replacingOccurrences(of: " ", with: "")

               
                let lines = trimmedString.split { $0.isNewline }
                let result = lines.joined(separator: "\n")
                
            
                
                
                DispatchQueue.main.async {
                    self.labelEnglish.text = word
                    self.labelTurkish.text = result
                }
            
                
                
                
                
                
                
            
                
              

                
            }
         
            
        })
        datatask?.resume()
    }
    
    
    func popUpTranslationView() {
        
        firstRect = CGRect(x:  5 + topView.frame.minX, y: -300, width: topView.frame.width - 10, height: 150)
        
        
        popUpView.frame = firstRect
        popUpView.backgroundColor = UIColor.flatSkyBlue()
        popUpView.layer.cornerRadius = 5
        self.view.addSubview(popUpView)
        
       
        
        let buttonAdd = UIButton(type: .contactAdd)
        let buttonDismiss = UIButton(type: .system)
        
        labelEnglish.frame = CGRect(x: popUpView.frame.width/2 - 100, y: 10, width: 200, height: 30)
        labelEnglish.layer.cornerRadius = 5
        labelEnglish.backgroundColor = UIColor.white
        labelEnglish.textAlignment = .center
        labelEnglish.numberOfLines = 0
         labelTurkish.textColor = UIColor.blue
        popUpView.addSubview(labelEnglish)
        
        labelTurkish.frame = CGRect(x: popUpView.frame.width/2 - 100, y: 70, width: 200, height: 30)
        labelTurkish.layer.cornerRadius = 5
        labelTurkish.backgroundColor = UIColor.white
        labelTurkish.textAlignment = .center
        labelTurkish.textColor = UIColor.red
        labelTurkish.numberOfLines = 0
      
       
        
      
        popUpView.addSubview(labelTurkish)
        
        
        buttonAdd.frame = CGRect(x: popUpView.frame.width - 40, y: 10, width: 30, height: 30)
        buttonAdd.layer.cornerRadius = 15
        buttonAdd.backgroundColor = UIColor.clear
        buttonAdd.tintColor = UIColor.white
        
        
        popUpView.addSubview(buttonAdd)
        
        
        buttonDismiss.frame = CGRect(x: popUpView.frame.width/2 - 50, y: popUpView.frame.height - 30, width: 100, height: 20)
        buttonDismiss.layer.cornerRadius = 10
        buttonDismiss.backgroundColor = UIColor.white
        buttonDismiss.setTitle("Close", for: .normal)
        
        buttonDismiss.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        
        self.popUpView.addSubview(buttonDismiss)
       
        
        
        
        
        
        
        
    }
    
    @objc func dismissPopUp() {
       
        popUpView.frame = firstRect
    }
    

    
}
