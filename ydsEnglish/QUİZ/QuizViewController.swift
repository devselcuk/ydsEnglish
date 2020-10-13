//
//  QuizViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 11.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage


class QuizViewController: UIViewController {
   
    
  
    
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
  
  
    
    
    
    var ref : DatabaseReference?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet var imageViews: [UIImageView]!
    var timerIsRunning = false
    
    @IBOutlet weak var timeView: UIView!
    let QTextView = UILabel()
    let ATextView1 = UILabel()
     let ATextView2 = UILabel()
     let ATextView3 = UILabel()
     let ATextView4 = UILabel()
     let ATextView5 = UILabel()
    
    var ATextViews = [UILabel]()
    
    let answers = ["Albert Enstein","Niels Bohr","Isaac Newton","Enrico Fermi","Kate Upton"]
    
    let gradient = CAGradientLayer()
    
       let myId = Auth.auth().currentUser?.uid
    
    var myUserName : String?
    var iAmStarter : Bool?
    var opponentUserName : String?
    var gameId : String?
    
    var newArr = [String]()
    
    var tenIndex = [Int]()
     let allWordsForQuiz = allWords + allWords1 + allWords2
   var questionIndex = 0
    var answersArray = [Int]()
    
    var homeScore = 0
    var awayScore = 0
    
    func createAnswers() {
        
       answersArray = []
        
        for i in 0...allWordsForQuiz.count - 1 {
            
             guard answersArray.count < 5 else { break }
            
            if i == 0 {
            
                answersArray.append(tenIndex[questionIndex])
            } else {
                
                let randomInd = Int.random(in: 0...9)
                if !answersArray.contains(tenIndex[randomInd]) {
                    answersArray.append(tenIndex[randomInd])
                    
                }
                
                
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.isHidden = true
        winnerLabel.isHidden = true
  
        
        
        ref =  Database.database().reference()
        
        print("winnnnnn\(userDefaults.integer(forKey: "win"))")
        
        for v in imageViews {
            v.layer.cornerRadius = v.frame.height / 2
        }
        
        for _ in 0...allWordsForQuiz.count {
       
            
            guard tenIndex.count < 10 else { break }
            let ind = Int.random(in: 0...allWordsForQuiz.count - 1)
            
            if !tenIndex.contains(ind) {
                tenIndex.append(ind)
            }
            
        }
        
        createAnswers()
        
        
        ATextViews = [ATextView1,ATextView2,ATextView3,ATextView4,ATextView5]
    
        let arr = [myUserName!, opponentUserName!]
        
         newArr = arr.sorted {$0 < $1 }
        
        
        nameLabel.text = "\(newArr[0]) vs \(newArr[1])"
       
        
        if newArr[0] == myUserName! {
            ref?.child("PlayGame").childByAutoId().child(newArr[0]).child(newArr[1]).setValue(["status":"active","index":self.tenIndex[self.questionIndex],newArr[0]:5,newArr[1]:5, "A":answersArray[0], "B":answersArray[1], "C":answersArray[2], "D":answersArray[3], "E":answersArray[4], "\(newArr[0])Score":homeScore,  "\(newArr[1])Score":awayScore ])
            
            
            
            
            startObserving()
            
            
            
        } else {
           
            startObserving()
            
      
        }
        
        
        
        
        UIView.animate(withDuration: 1) {
            self.ATextView1.backgroundColor = blueSky
        }
        
        
        basicAnim.toValue = 1
        basicAnim.duration = 25
        basicAnim.isRemovedOnCompletion = false
       
        
       let storage = Storage.storage().reference()
        
        storage.child("IMG_7137.JPG").getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                
                for view in self.imageViews {
                    view.layer.cornerRadius = 35
                    view.image = image
                }
            }
            
           
        }
  
        
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapHandle1))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapHandle2))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapHandle3))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapHandle4))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapHandle5))
        ATextView1.addGestureRecognizer(tap1)
        ATextView2.addGestureRecognizer(tap2)
        ATextView3.addGestureRecognizer(tap3)
        ATextView4.addGestureRecognizer(tap4)
        ATextView5.addGestureRecognizer(tap5)
        
        
        
        
   

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        topView.backgroundColor = UIColor.red
        
        view.backgroundColor = UIColor.red
        
        
        gradient.colors = [grRed.cgColor, grOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        
        gradient.frame = self.view.bounds
        
        
        
        
        
        let shapeLayer = CAShapeLayer()
        let ovalRect = CGRect(x: topView.frame.minX - 5, y: topView.frame.minY + topView.frame.height/3 - 5 , width: 10, height: 10)
        shapeLayer.path = UIBezierPath(ovalIn: ovalRect).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let shapeLayerRight = CAShapeLayer()
        let ovalRectRight = CGRect(x: topView.frame.maxX - 5, y: topView.frame.minY + topView.frame.height/3 - 5 , width: 10, height: 10)
        shapeLayerRight.path = UIBezierPath(ovalIn: ovalRectRight).cgPath
        shapeLayerRight.fillColor = UIColor.red.cgColor
        
        
        
        view.backgroundColor = UIColor.clear
        self.view.layer.insertSublayer(gradient, at: 0)
        
        view.layer.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayerRight)
       
        gradient.frame = self.view.bounds
        QTextView.frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height/3)
        
        ATextView1.frame = CGRect(x: 0, y: QTextView.frame.height + 1, width: topView.frame.width, height: (topView.frame.height/3)*2/5)
        ATextView2.frame = CGRect(x: 0, y: QTextView.frame.height + ATextView1.frame.height + 2, width: topView.frame.width, height: (topView.frame.height/3)*2/5)
        ATextView3.frame = CGRect(x: 0, y: QTextView.frame.height + ATextView1.frame.height + ATextView2.frame.height + 3, width: topView.frame.width, height: (topView.frame.height/3)*2/5)
        ATextView4.frame = CGRect(x: 0, y: QTextView.frame.height + ATextView1.frame.height + ATextView2.frame.height + ATextView3.frame.height + 4, width: topView.frame.width, height: (topView.frame.height/3)*2/5)
        ATextView5.frame = CGRect(x: 0, y: QTextView.frame.height + ATextView1.frame.height + ATextView2.frame.height + ATextView3.frame.height + ATextView4.frame.height + 5, width: topView.frame.width, height: (topView.frame.height/3)*2/5)
         addLayers(width: topView.frame.width)
        topView.addSubview(QTextView)
        topView.addSubview(ATextView1)
        topView.addSubview(ATextView2)
        topView.addSubview(ATextView3)
        topView.addSubview(ATextView4)
        topView.addSubview(ATextView5)
        
        let center = CGPoint(x: timeView.frame.width/2, y: timeView.frame.height/2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: 50, startAngle: -CGFloat( Double.pi / 2)  , endAngle:CGFloat(2 * Double.pi), clockwise: true).cgPath
        
        circleLayer.path = circlePath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.white.cgColor
        
        
        circleLayer.strokeEnd = 0
        timeView.backgroundColor = UIColor.clear
        
       
      
        
        timeLabel.text = "\(seconds)"
        
        
        timeLabel.frame = CGRect(x: timeView.frame.width/2 - 30, y: timeView.frame.height/2 - 30 , width: 60, height: 60)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "Futura", size: 24)
        timeLabel.textColor = UIColor.white
        self.timeView.addSubview(timeLabel)
        
       
        
        self.timeView.layer.addSublayer(circleLayer)
        
        
        let answerTextViews = [ATextView1, ATextView2,ATextView3,ATextView4, ATextView5]
        
        for view in answerTextViews {
         
            view.font = UIFont(name: "Futura", size: 20)
            view.textAlignment = .center
            view.backgroundColor = UIColor.white
            view.numberOfLines = 0
            view.isUserInteractionEnabled = true
        }
        
        QTextView.font = UIFont(name: "Futura-Bold", size: 40)
        QTextView.textAlignment = .center
        QTextView.numberOfLines = 0
        QTextView.backgroundColor = UIColor.white
        QTextView.textColor = UIColor.flatRed()
        
     self.topView.bringSubviewToFront(resultView)
        self.topView.bringSubviewToFront(winnerLabel)
    
   
    }
    
    
    @IBAction func start(_ sender: UIButton) {
   
        
    }
    
    
    
    
    let circleLayer = CAShapeLayer()
    let basicAnim = CABasicAnimation(keyPath: "strokeEnd")
    var timer : Timer?
    let timeLabel = UILabel()
    var seconds = 20
    
    var userFound = false
   
    
    @objc func updateTimer () {
     
        if seconds == 0 {
            timer?.invalidate()
            timer = nil
        }
            self.timeLabel.text = "\(self.seconds)"
            
          self.seconds -= 1
 
    
    }
    var myAnswer : Int?
    var yourAnswer : Int?
    
    
    @IBAction func dismissGame(_ sender: UIButton) {
        
        
        self.dismiss(animated: true) {
            
            
            self.turnOff()
        }
        
      
        
        
    }
    
    
    
    
    
    
    @objc func tapHandle1() {
        for v in ATextViews {
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = false
        }
        
        
      
        myAnswer = 0
        
        ATextViews[0].backgroundColor = UIColor.grapefruit
     
        updateMyAnswer(myAnswer: 0)
        
    
    
    }
    @objc func tapHandle2() {
        for v in ATextViews {
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = false
        }
        myAnswer = 1
        
        ATextViews[1].backgroundColor = UIColor.grapefruit
        
         updateMyAnswer(myAnswer: 1)
      
       
        
    }
    @objc func tapHandle3() {
        for v in ATextViews {
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = false
        }
           myAnswer = 2
        ATextViews[2].backgroundColor = UIColor.grapefruit
         updateMyAnswer(myAnswer: 2)
       
    }
    @objc func tapHandle4() {
        for v in ATextViews {
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = false
        }
           myAnswer = 3
        ATextViews[3].backgroundColor = UIColor.grapefruit
        
        updateMyAnswer(myAnswer: 3)
    }
    @objc func tapHandle5() {
        for v in ATextViews {
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = false
        }
        
        
           myAnswer = 4
        ATextViews[4].backgroundColor = UIColor.grapefruit
         updateMyAnswer(myAnswer: 4)
       
    }
 
    
    func addLayers (width : CGFloat) {
        for i in 0...Int(width/7.5) {
            let layer = CAShapeLayer()
            let rect = CGRect(x: topView.frame.minX - 20  + CGFloat(i + (i * 6)), y: topView.frame.height/3, width: 4, height: 1)
            layer.path = UIBezierPath(rect: rect).cgPath
            layer.fillColor = UIColor.white.cgColor
            
            topView.layer.addSublayer(layer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
  
    
    func checkFirebase() {
        
        
        
    }
    
    func checkOpponentClick() {
        
        
        
        
    }
    
    func zeroAllData() {
        
        ref?.child("PlayGame").observe(.childAdded, with: { (mainSnap) in
           
            
            
            
            for child in mainSnap.children {
                if let childSnap = child as? DataSnapshot {
                 
                    
                    if childSnap.key == self.newArr[0] {
                        
                        
                        if let info = childSnap.value! as? [String:[String:Any?]] {
                            if Array(info.keys)[0] == self.newArr[1] {
                                let values = Array(info.values)
                                
                                for value in values {
                                    
                                    if value["status"] as! String == "active" {
                                   self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).updateChildValues([self.myUserName! : 5, self.opponentUserName! : 5])
                      
                                    }
               
                                }
             
                            }
                        }
                    }
      
                }
            }
        })
        
    }
    
    
    
    func updateMyAnswer(myAnswer : Int) {
        
        ref?.child("PlayGame").observe(.childAdded, with: { (mainSnap) in
        
            
            
            
            for child in mainSnap.children {
                if let childSnap = child as? DataSnapshot {
                
                    
                    if childSnap.key == self.newArr[0] {
                   
                        
                        if let info = childSnap.value! as? [String:[String:Any?]] {
                            if Array(info.keys)[0] == self.newArr[1] {
                                let values = Array(info.values)
                                
                                for value in values {
                                    
                                    if value["status"] as! String == "active" {
                                        
                                        
                                        
                                        self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).updateChildValues([self.myUserName! : myAnswer])
                                        
            
                                        
                                        
                                    }
            
                                }
         
                            }
                        }
                    }
     
                }
            }
        })

    }
 
    
    
    
    
    func startObserving() {
        
        ref?.child("PlayGame").observe(.childAdded, with: { (mainSnap) in
           
                  for child in mainSnap.children {
                if let childSnap = child as? DataSnapshot {
                
                    
                    if childSnap.key == self.newArr[0] {
                        
                        
                        if let info = childSnap.value! as? [String:[String:Any?]] {
                            if Array(info.keys)[0] == self.newArr[1] {
                                let values = Array(info.values)
                                
                                for value in values {
                                 
                                    
                                    if value["status"] as! String == "inactive" {
                                        continue
                                    }
                                    
                                 
                                    
                                    if value["status"] as! String == "active" {
                                      
                                        
                                        
                                        self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).observe(.value, with: { (aimSnap) in
                                    
                                            
                                           
                                            
                                            if let data = aimSnap.value as? [String: Any] {
                                           
                                                
                                                if let opponentsAnswer = data[self.opponentUserName!] as? Int {
                                                   
                                                    
                                                  
                                                    
                                                    if let status = data["status"] as? String {
                                                  
                                        
                                                        
                                                        if status == "inactive" {
                                                            
                                                          
                                                            self.dismiss(animated: true, completion: {
                                                            self.ref?.child("PlayGame").removeAllObservers()
                                                            })
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                 
                                                    let home =  data[self.newArr[0]] as! Int
                                                    let away = data[self.newArr[1]] as! Int
                                                    let index = data["index"] as! Int
                                                    
                                                   
                                                    if home < 5 && away < 5 {
                                                        
                                                        
                                                        if self.timerIsRunning {
                                                            
                                                            self.timer?.invalidate()
                                                            self.timer = nil
                                                            
                                                            self.circleLayer.removeAllAnimations()
                                                            
                                                            self.seconds = 20
                                                            
                                                            self.timerIsRunning = false
                                                        }
                                                        
                                                        
                                                    
                                                       
                                                        
                                                        
                                                       
                                                        if opponentsAnswer < 5 {
                                                            for t in self.ATextViews{
                                                                if t.backgroundColor == UIColor.flatMagenta() {
                                                                    t.backgroundColor = UIColor.white
                                                                }
                                                            }
                                                            self.ATextViews[opponentsAnswer].backgroundColor = UIColor.flatMagenta()
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        if self.questionIndex == 9 {
                                                            
                                                          
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                                                self.resultView.isHidden = false
                                                                
                                                                if self.homeScore > self.awayScore {
                                                                    
                                                                    
                                                                    
                                                                    self.evaluateGameResult(won: true)
                                                                    
                                                                    
                                                                    var emoji = ""
                                                                    
                                                                    if self.newArr[0] == self.myUserName! {
                                                                        emoji = "🤩"
                                                                    } else {
                                                                        emoji = "😢"
                                                                    }
                                                                    
                                                                    self.resultLabel.text = "\(self.newArr[0]) won the Game \(emoji)"
                                                                    
                                                                    
                                                                } else if self.homeScore < self.awayScore {
                                                                    var emoji = ""
                                                                    self.evaluateGameResult(won: false)
                                                                    
                                                                    if self.newArr[0] == self.myUserName! {
                                                                        emoji = "😢"
                                                                    } else {
                                                                        emoji = "🤩"
                                                                    }
                                                                    
                                                                    self.resultLabel.text = "\(self.newArr[1]) won the Game \(emoji)"
                                                                    
                                                                } else {
                                                                    self.resultLabel.text = "Berabere Bitti ☹️"
                                                                }
                                                            })
                                                            
                                                      
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                            
                                                            
                                                            for v in self.ATextViews {
                                                                v.backgroundColor = UIColor.white
                                                            }
                                                            
                                                            
                                                            if self.ATextViews[home].text == self.allWordsForQuiz[index].turkishMeaning && self.ATextViews[away].text !=  self.allWordsForQuiz[index].turkishMeaning {
                                                                
                                                               
                                                                self.homeScore += 1
                                                                
                                                                self.scoreLabel.text = "\(self.homeScore) : \(self.awayScore)"
                                                                self.winnerLabel.isHidden = false
                                                                self.winnerLabel.text = "\(self.newArr[0]) knew!!!"
                                                              
                                                                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .autoreverse, animations: {
                                                                    self.winnerLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                                                                }, completion: { (true) in
                                                                    self.winnerLabel.transform = .identity
                                                                })
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                                    self.winnerLabel.isHidden = true
                                                                })
                                                                
                                                                
                                                            }
                                                            if self.ATextViews[away].text == self.allWordsForQuiz[index].turkishMeaning && self.ATextViews[home].text !=  self.allWordsForQuiz[index].turkishMeaning  {
                                              
                                                                self.awayScore += 1
                                                                  self.scoreLabel.text = "\(self.homeScore) : \(self.awayScore)"
                                                                
                                                                self.winnerLabel.isHidden = false
                                                                self.winnerLabel.text = "\(self.newArr[1]) knew!!!"
                                                               
                                                                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .autoreverse, animations: {
                                                                    self.winnerLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                                                                }, completion: { (true) in
                                                                    self.winnerLabel.transform = .identity
                                                                })
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                                    self.winnerLabel.isHidden = true
                                                                })
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            if self.ATextViews[away].text != self.allWordsForQuiz[index].turkishMeaning && self.ATextViews[home].text !=  self.allWordsForQuiz[index].turkishMeaning  {
                                                                
                                                                
                                                                self.scoreLabel.text = "\(self.homeScore) : \(self.awayScore)"
                                                                
                                                                self.winnerLabel.isHidden = false
                                                                self.winnerLabel.text = "Nobody knew!!!"
                                                               
                                                                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .autoreverse, animations: {
                                                                    self.winnerLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                                                                }, completion: { (true) in
                                                                    self.winnerLabel.transform = .identity
                                                                })
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                                    self.winnerLabel.isHidden = true
                                                                })
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            if self.ATextViews[away].text == self.allWordsForQuiz[index].turkishMeaning && self.ATextViews[home].text ==  self.allWordsForQuiz[index].turkishMeaning  {
                                                                self.homeScore += 1
                                                                self.awayScore += 1
                                                                
                                                                self.scoreLabel.text = "\(self.homeScore) : \(self.awayScore)"
                                                                
                                                                self.winnerLabel.isHidden = false
                                                                self.winnerLabel.text = "Both of you knew!!!"
                                                            
                                                                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .autoreverse, animations: {
                                                                    self.winnerLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                                                                }, completion: { (true) in
                                                                    self.winnerLabel.transform = .identity
                                                                    
                                                                    
                                                                })
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                                                    self.winnerLabel.isHidden = true
                                                                })
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            if self.newArr[0] == self.myUserName! {
                                                                
                                                                guard self.questionIndex < 9 else { return}
                                                                
                                                                self.questionIndex += 1
                                                                print("questionindex")
                                                                print(self.questionIndex)
                                                                
                                                                
                                                        self.createAnswers()
                                                            
                                                                self.answersArray.shuffle()
                                                                self.QTextView.text = self.allWordsForQuiz[self.tenIndex[self.questionIndex]].word
                                                                
                                                                for i in 0...4 {
                                                                    self.ATextViews[i].text = self.allWordsForQuiz[self.answersArray[i]].turkishMeaning
                                                                }
                                                        
                                                           self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).updateChildValues(["index":self.tenIndex[self.questionIndex],self.newArr[0]:5,self.newArr[1]:5, "A":self.answersArray[0], "B":self.answersArray[1], "C":self.answersArray[2], "D":self.answersArray[3], "E":self.answersArray[4], "\(self.newArr[0])Score":self.homeScore,  "\(self.newArr[1])Score":self.awayScore ])
                                                                
                                                              
                                                      
                                                            } else {
                                                                self.questionIndex += 1
                                                                
                                                                if self.questionIndex == 10 {
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                                                        self.resultView.isHidden = false
                                                                        
                                                                        if self.homeScore > self.awayScore {
                                                                            var emoji = ""
                                                                           
                                                                            self.evaluateGameResult(won: false)
                                                                            
                                                                            if self.newArr[0] == self.myUserName! {
                                                                                emoji = "🤩"
                                                                            } else {
                                                                                emoji = "😢"
                                                                            }
                                                                            
                                                                            self.resultLabel.text = "\(self.newArr[0]) won the Game \(emoji)"
                                                                            
                                                                            
                                                                        } else if self.homeScore < self.awayScore {
                                                                           self.evaluateGameResult(won: true)
                                                                            var emoji = ""
                                                                            
                                                                            if self.newArr[0] == self.myUserName! {
                                                                                emoji = "😢"
                                                                            } else {
                                                                                emoji = "🤩"
                                                                            }
                                                                            
                                                                            self.resultLabel.text = "\(self.newArr[1]) won the Game \(emoji)"
                                                                            
                                                                        } else {
                                                                            self.resultLabel.text = "Berabere Bitti ☹️"
                                                                        }
                                                                    })
                                                                    
                                                                    
                                                                }
                                                                
                                                            }
                                               
                                                        })
                                                    } else {
                                                        
                                                        if !self.timerIsRunning {
                                                            for t in self.ATextViews {
                                                                t.isUserInteractionEnabled = true
                                                            }
                                                            
                                                          
                                                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                                                                self.circleLayer.add(self.basicAnim, forKey: "time")
                                                                
                                                                self.timerIsRunning = true
                                                         
                                                             self.basicAnim.isRemovedOnCompletion = false
                                                            
                                                            
                                                            
                                                           
                                                            
                                                        }
                                                        
                                                    
                                                        
                                                        
                                                       
                                                        
                                                        
                                                        if self.newArr[0] != self.myUserName! {
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("index").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                  
                                                                    self.QTextView.text = self.allWordsForQuiz[qIndex].word
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("A").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                   
                                                                    self.ATextView1.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("B").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                   
                                                                    self.ATextView2.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("C").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView3.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("D").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView4.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("E").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView5.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        } else {
                                                            
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("index").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    
                                                                    self.QTextView.text = self.allWordsForQuiz[qIndex].word
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("A").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    
                                                                    self.ATextView1.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("B").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                  
                                                                    self.ATextView2.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("C").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView3.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("D").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView4.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).child("E").observe(.value, with: { (index) in
                                                                if let qIndex = index.value as? Int {
                                                                    self.ATextView5.text = self.allWordsForQuiz[qIndex].turkishMeaning
                                                                }
                                                            })
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }
                           
                                                    
                                                }
                                                
                                                
                                            }
                                        
                                        })
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                    
                    
                    
                }
            }
        })
        
    }
    
    
    
    
    
    
    func turnOff() {
        
        ref?.child("PlayGame").observe(.childAdded, with: { (mainSnap) in
        
            for child in mainSnap.children {
                if let childSnap = child as? DataSnapshot {
                 
                    if childSnap.key == self.newArr[0] {
                   
                        if let info = childSnap.value! as? [String:[String:Any?]] {
                            if Array(info.keys)[0] == self.newArr[1] {
                                let values = Array(info.values)
                                
                                
                                for value in values {
                                    
                                    
                                    
                                    if value["status"] as! String == "active" {
                              self.ref?.child("PlayGame").child(mainSnap.key).child(self.newArr[0]).child(self.newArr[1]).updateChildValues(["status":"inactive"])
                                        
                                        self.ref?.child("PlayGame").removeAllObservers()
                                        
                                        
                                      
                                        self.dismiss(animated: true, completion: {
                                         
                                        })
                                        
                                        
                                                        }
                                       }
                                
                            }
                        }
                    }
           
                }
            }
        })

    }
    

    func evaluateGameResult( won : Bool)  {
       
        
        var myWinGameScore = userDefaults.integer(forKey: "win")
        var myLoseGameScore = userDefaults.integer(forKey: "lose")
        
        if won {
            myWinGameScore += 1
            userDefaults.set(myWinGameScore, forKey: "win")
        } else {
            myLoseGameScore += 1
            userDefaults.set(myLoseGameScore, forKey: "lose")
        }
    }
}
