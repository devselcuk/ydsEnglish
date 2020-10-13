//
//  ProfileViewController.swift
//  DaysTableView
//
//  Created by çağrı on 27.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import TwitterKit



class ProfileViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var examSectionsView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var circleShapesView: UIView!
    
    var storage : StorageReference?
    
    @IBOutlet weak var uploadPhoto: UIButton!
    let pickerVC = UIImagePickerController()
    
    @IBAction func upload(_ sender: UIButton) {
        
        
        
        self.present(pickerVC, animated: true, completion: nil)
        
        
    }
    
    
    @objc func handlePick() {
         self.present(pickerVC, animated: true, completion: nil)
    }
    
    
    
  
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print(originalImage)
            imageView.image = originalImage
            let data = originalImage.pngData()
            
           userDefaults.setValue(data, forKey: "proPic")
            let username = userDefaults.string(forKey: "username")
            
            storage?.child("profilePics").child("\(username!)").putData(data!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("uploadingError\(error!)")
                    
                }
            })
            
           
            
            
            
            
        }
        
       pickerVC.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    var topViewFrame : CGRect?
    
    
     let layer = CAShapeLayer()
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        print("see here")
     print(trackedTypes)
        
        storage = Storage.storage().reference()
        
        let profilePic = userDefaults.data(forKey: "proPic")
        
        
        if profilePic != nil {
           imageView.image = UIImage(data: profilePic!)
        }
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePick))
        
        imageView.addGestureRecognizer(tap)
        
        
        
        
        pickerVC.delegate = self
        userNameLabel.text = userDefaults.string(forKey: "username")
        topViewFrame = topView.frame
        
        pointsLabel.text = "\(userDefaults.integer(forKey: "points")) points"
        
    scrollView.delegate = self
        
      

        view.bringSubviewToFront(topView)
        view.bringSubviewToFront(labelView)
        
        view.backgroundColor = UIColor(displayP3Red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
       
        
        labelView.layer.shadowOffset = CGSize(width: 0, height: 3)
        labelView.layer.shadowColor = UIColor.gray.cgColor
        labelView.layer.shadowOpacity = 0.5
        
        
        topView.backgroundColor = UIColor(displayP3Red: 117/255, green: 187/255, blue: 204/255, alpha: 1)
        
        
  examSectionsView.layer.cornerRadius = 10
        examSectionsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        examSectionsView.layer.shadowColor = UIColor.gray.cgColor
        examSectionsView.layer.shadowOpacity = 0.5
        
        
       
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var logout: UIView!
    let loginManager = LoginManager()
    @IBAction func logoutPressed(_ sender: UIButton) {
     
            do {
                try Auth.auth().signOut()
                loginManager.logOut()
                let store = TWTRTwitter.sharedInstance().sessionStore
                
                if let userID = store.session()?.userID {
                    store.logOutUserID(userID)
                }
                
                userDefaults.set(0, forKey: "loggedIn")
                performSegue(withIdentifier: "logout", sender: Any.self)
                
                
            } catch {
                print(error.localizedDescription)
            }
        
        
        
        
        
        
        
    }
    
    var examURL : URL?
   var examRights = 0
  var   examWrongs = 0
    var answeredQuestions = [AnsweredQuestion]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let data = try? Data(contentsOf: trackTypeURL) {
            do {
                trackedTypes = try! decoder.decode([TrackTypeAnswer].self, from: data)
                
            }
            
            
        }
        let examCount = userDefaults.integer(forKey: "examCount")
        
        for i in 0..<examCount {
            examURL = examDirectory.appendingPathComponent("exam\(i)").appendingPathExtension("plist")
            
            if let data = try? Data(contentsOf: examURL!) {
                do {
                    answeredQuestions = try decoder.decode([AnsweredQuestion].self, from: data)
                } catch {
                    print(error)
                }
            }
            
            print("\(answeredQuestions)  examQ")
            
            
            for i in answeredQuestions {
                if i.correctAnswer == i.givenAnswer {
                    examRights += 1
                } else {
                    examWrongs += 1
                }
            }
            
            print(examRights)
            print(examWrongs)
            
            
        }
        
      
        
        
        pointsLabel.text = "\(userDefaults.integer(forKey: "points")) points"
        
      
        
        
     
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let centerOne = CGPoint(x: self.circleShapesView.frame.width/6, y: self.circleShapesView.frame.height/2)
            let centerTwo = CGPoint(x: self.circleShapesView.frame.width/2, y: self.circleShapesView.frame.height/2)
            let centerThree =  CGPoint(x: (5 * self.circleShapesView.frame.width)/6, y: self.circleShapesView.frame.height/2)
            let colorTwo = UIColor(displayP3Red: 167/255, green: 174/255, blue: 204/255, alpha: 1)
            let colorThree = UIColor(displayP3Red: 225/255, green: 173/255, blue: 195/255, alpha: 1)
            self.drawUselessLine()
            self.viewShadow()
            
            let rightWord = userDefaults.integer(forKey: "rightWord")
            let wrongWord = userDefaults.integer(forKey: "wrongWord")
            
            var intForWord = CGFloat(CGFloat(rightWord)/CGFloat(rightWord + wrongWord))
            
            if rightWord + wrongWord == 0 {
                intForWord = 0
            }
            
            
            
            let percentage = Int(intForWord * 100)
            
            
            
            
            intForWord = intForWord * 0.79
            
            
            
            self.drawStatCircles(color: self.topView.backgroundColor!, center: centerOne, strokeEnd: intForWord, labelText: "\(percentage)%")
            
            
            var intForExam = CGFloat(CGFloat(self.examRights)/CGFloat(self.examRights + self.examWrongs))
            
            if self.examRights + self.examWrongs == 0 {
                intForExam = 0
            }
            
            print("\(intForExam) exampp")
            
            let examPercentage = Int( intForExam * 100 )
            
            intForExam = intForExam * 0.79
            
            
            self.drawStatCircles(color: colorTwo, center: centerTwo, strokeEnd: intForExam, labelText: "\(examPercentage)%")
            
            let wins = userDefaults.integer(forKey: "win")
            let loses = userDefaults.integer(forKey: "lose")
            
            var gameStrokeEnd = CGFloat(CGFloat(wins)/CGFloat(wins + loses))
            if wins + loses == 0 {
                gameStrokeEnd = 0
            }
            let gamePercentage = gameStrokeEnd * 100
            
            gameStrokeEnd = gameStrokeEnd * 0.8
            
            
            self.drawStatCircles(color: colorThree, center: centerThree, strokeEnd: gameStrokeEnd, labelText: "\(Int(gamePercentage))%")
            self.createCentersForExamView()
          
        }
        
        
        
        
    }
     let path = UIBezierPath()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let examCount = userDefaults.integer(forKey: "examCount")
        
        for i in 0..<examCount {
            examURL = examDirectory.appendingPathComponent("exam\(i)").appendingPathExtension("plist")
            
            if let data = try? Data(contentsOf: examURL!) {
                do {
                    answeredQuestions = try decoder.decode([AnsweredQuestion].self, from: data)
                } catch {
                    print(error)
                }
            }
            
            print("\(answeredQuestions)  examQ")
            
            
            for i in answeredQuestions {
                if i.correctAnswer == i.givenAnswer {
                    examRights += 1
                } else {
                    examWrongs += 1
                }
            }
            
            print(examRights)
            print(examWrongs)
            
            
        }
       
       
        
        path.move(to: CGPoint(x: 0, y: topView.frame.height))
        
        path.addLine(to: CGPoint(x: topView.frame.width/2 - 20, y: topView.frame.height))
        path.addLine(to: CGPoint(x: topView.frame.width/2, y: topView.frame.height - 20))
        
        path.addLine(to: CGPoint(x: topView.frame.width/2 + 20, y: topView.frame.height))
        path.move(to: CGPoint(x: topView.frame.width, y: topView.frame.height))
        path.addClip()
        path.close()
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        
        topView.layer.insertSublayer(layer, at: 1)
      
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let centerOne = CGPoint(x: self.circleShapesView.frame.width/6, y: self.circleShapesView.frame.height/2)
            let centerTwo = CGPoint(x: self.circleShapesView.frame.width/2, y: self.circleShapesView.frame.height/2)
            let centerThree =  CGPoint(x: (5 * self.circleShapesView.frame.width)/6, y: self.circleShapesView.frame.height/2)
            let colorTwo = UIColor(displayP3Red: 167/255, green: 174/255, blue: 204/255, alpha: 1)
            let colorThree = UIColor(displayP3Red: 225/255, green: 173/255, blue: 195/255, alpha: 1)
            self.drawUselessLine()
            self.viewShadow()
            
            let rightWord = userDefaults.integer(forKey: "rightWord")
            let wrongWord = userDefaults.integer(forKey: "wrongWord")
        
               var intForWord = CGFloat(CGFloat(rightWord)/CGFloat(rightWord + wrongWord))
            
            if rightWord + wrongWord == 0 {
                intForWord = 0
            }
            
         
            
            let percentage = Int(intForWord * 100)
            
           
            
            
            intForWord = intForWord * 0.79
            
           
            
            self.drawStatCircles(color: self.topView.backgroundColor!, center: centerOne, strokeEnd: intForWord, labelText: "\(percentage)%")
            var intForExam = CGFloat(CGFloat(self.examRights)/CGFloat(self.examRights + self.examWrongs))
            
            print("\(intForExam) exampp")
            
            if self.examRights + self.examWrongs == 0 {
                intForExam = 0
            }
            
            let examPercentage = Int( intForExam * 100 )
            
            intForExam = intForExam * 0.79
            
            
            self.drawStatCircles(color: colorTwo, center: centerTwo, strokeEnd: intForExam, labelText: "\(examPercentage)%")
            let wins = userDefaults.integer(forKey: "win")
            let loses = userDefaults.integer(forKey: "lose")
            
            var gameStrokeEnd = CGFloat(CGFloat(wins)/CGFloat(wins + loses))
            if wins + loses == 0 {
                gameStrokeEnd = 0
            }
            let gamePercentage = gameStrokeEnd * 100
            
            gameStrokeEnd = gameStrokeEnd * 0.8
            self.drawStatCircles(color: colorThree, center: centerThree, strokeEnd: gameStrokeEnd, labelText: "\(Int(gamePercentage))%")
            self.createCentersForExamView()
         
        }
      
        
        
        
    }
    
    
    
    
    func drawUselessLine() {
        let layer = CAShapeLayer()
        let rect = CGRect(x: 20, y: 30, width: circleShapesView.frame.width - 20, height: 1)
        layer.path = UIBezierPath(rect: rect).cgPath
        layer.fillColor = self.view.backgroundColor?.cgColor
        circleShapesView.layer.addSublayer(layer)
    }
    
    func viewShadow() {
        circleShapesView.layer.cornerRadius = 5
        circleShapesView.layer.shadowOffset = CGSize(width: 0, height: 5)
        circleShapesView.layer.shadowColor = UIColor.gray.cgColor
        circleShapesView.layer.shadowOpacity = 0.5
    }
    
    func drawStatCircles(color : UIColor , center : CGPoint, strokeEnd: CGFloat, labelText: String) {
        
        let circleOneLayer = CAShapeLayer()
         circleOneLayer.path = UIBezierPath(arcCenter: center, radius: 75/2, startAngle: -CGFloat( Double.pi / 2), endAngle: CGFloat(2 * Double.pi), clockwise: true).cgPath
        
        circleOneLayer.strokeEnd = 1
        circleOneLayer.lineWidth = 10
        
        circleOneLayer.strokeColor = view.backgroundColor?.cgColor
        circleOneLayer.fillColor = UIColor.clear.cgColor
       
        
        let circleOneColorLayer = CAShapeLayer()
        circleOneColorLayer.path = UIBezierPath(arcCenter: center, radius: 75/2, startAngle: -CGFloat(Double.pi  / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        circleOneColorLayer.strokeEnd = 0
        circleOneColorLayer.lineWidth = 10
        
        circleOneColorLayer.strokeColor = color.cgColor
        circleOneColorLayer.fillColor = UIColor.clear.cgColor
        circleOneColorLayer.lineCap = .round
        
        let label = UILabel()
        label.frame = CGRect(x: center.x - 20, y: center.y - 20, width: 40, height: 40)
        label.backgroundColor = UIColor.white
        label.textColor = color
        label.textAlignment = .center
        label.text = labelText
        label.font = UIFont(name: "Futura-Bold", size: 14)
        
        let basicAnim = CABasicAnimation(keyPath: "strokeEnd")
        basicAnim.duration = 0.5
        basicAnim.fromValue = 0
        basicAnim.toValue = strokeEnd
        basicAnim.fillMode = CAMediaTimingFillMode.forwards
      basicAnim.isRemovedOnCompletion = false
        
       
        
        circleOneColorLayer.add(basicAnim, forKey: "anim")
        
        
        circleShapesView.layer.addSublayer(circleOneLayer)
        circleShapesView.layer.addSublayer(circleOneColorLayer)
        circleShapesView.addSubview(label)
        
        
    }
    
    func createCentersForExamView() {
        
        let widthOfView = examSectionsView.frame.width
        let heightOfView = examSectionsView.frame.height
        

        
        let centerOne = CGPoint(x: widthOfView/6, y: heightOfView/6)
        let centerTwo = CGPoint(x: widthOfView/2, y: heightOfView/6)
        
        
        let centerThree = CGPoint(x: (5*widthOfView)/6, y: heightOfView/6)
         let centerFour = CGPoint(x: widthOfView/6, y: heightOfView/2)
        let centerFive = CGPoint(x: widthOfView/2, y: heightOfView/2)
        let centerSix = CGPoint(x: (5*widthOfView)/6, y: heightOfView/2)
        let centerSeven = CGPoint(x: widthOfView/6, y: (5 * heightOfView)/6)
        let centerEight = CGPoint(x: widthOfView/2, y: (5 * heightOfView)/6)
        let centerNine = CGPoint(x: (5*widthOfView)/6, y: (5 * heightOfView)/6)
        let colorTwo = UIColor(displayP3Red: 167/255, green: 174/255, blue: 204/255, alpha: 1)
        let colorThree = UIColor(displayP3Red: 225/255, green: 173/255, blue: 195/255, alpha: 1)
        
        
        addCirclestoExamView(color: topView.backgroundColor!, center: centerOne, int: 1)
        addCirclestoExamView(color: colorTwo, center: centerTwo, int: 2)
        addCirclestoExamView(color: colorThree, center: centerThree, int: 3)
        addCirclestoExamView(color: topView.backgroundColor!, center: centerFour, int: 4)
        addCirclestoExamView(color: colorTwo, center: centerFive, int: 5)
        addCirclestoExamView(color: colorThree, center: centerSix, int: 6)
        addCirclestoExamView(color: topView.backgroundColor!, center: centerSeven, int: 7)
        addCirclestoExamView(color: colorTwo, center: centerEight, int: 8)
        addCirclestoExamView(color: colorThree, center: centerNine, int: 9)
       
    }
    
    
    
    func addCirclestoExamView(color: UIColor , center : CGPoint, int : Int) {
        
        
        
        let circleOneLayer = CAShapeLayer()
        circleOneLayer.path = UIBezierPath(arcCenter: center, radius: 75/2, startAngle: -CGFloat( Double.pi / 2), endAngle: CGFloat(2 * Double.pi), clockwise: true).cgPath
        
        circleOneLayer.strokeEnd = 1
        circleOneLayer.lineWidth = 10
        
        circleOneLayer.strokeColor = view.backgroundColor?.cgColor
        circleOneLayer.fillColor = UIColor.clear.cgColor
        
       
        
        let label = UILabel()
        label.frame = CGRect(x: center.x - 22.5, y: center.y - 22.5, width: 45, height: 45)
        label.backgroundColor = UIColor.white
        label.textColor = color
        label.textAlignment = .center
        label.text = "25%"
        label.font = UIFont(name: "Futura-Bold", size: 14)
        
        let secondLabel = UILabel()
        
        secondLabel.frame = CGRect(x: center.x - 50, y: center.y + 25, width: 100, height: 50)
        secondLabel.backgroundColor = UIColor.clear
        secondLabel.textColor = color
        secondLabel.textAlignment = .center
        secondLabel.numberOfLines = 0
        
        
    
       
        
        let circleOneColorLayer = CAShapeLayer()
        circleOneColorLayer.path = UIBezierPath(arcCenter: center, radius: 75/2, startAngle: -CGFloat(Double.pi  / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
       
        circleOneColorLayer.lineWidth = 10
        
        circleOneColorLayer.strokeColor = color.cgColor
        circleOneColorLayer.fillColor = UIColor.clear.cgColor
        circleOneColorLayer.lineCap = .round
        
        
        
        switch int {
        case 1:
            secondLabel.text = "Kelime"
            let s = trackedTypes.firstIndex(where: {$0.type == .word})
            
            
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text =  "0%"
            }
            
           
        
            
        case 2 :
            secondLabel.text = "Cloze Test"
            let s = trackedTypes.firstIndex(where: {$0.type == .clozeTest})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 3:
            secondLabel.text = "Cümle"
            let s = trackedTypes.firstIndex(where: {$0.type == .sentenceCompleting})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 4 :
            secondLabel.text = "Çeviri"
            let s = trackedTypes.firstIndex(where: {$0.type == .translation})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 5:
            secondLabel.text = "Paragraf"
            let s = trackedTypes.firstIndex(where: {$0.type == .paragraph})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 6 :
            secondLabel.text = "Diyalog"
            let s = trackedTypes.firstIndex(where: {$0.type == .dialogue})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 7:
            secondLabel.text = "Yakın Anlam"
            let s = trackedTypes.firstIndex(where: {$0.type == .closeMeaning})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 8 :
            secondLabel.text = "Paragraf Tamamlama"
            let s = trackedTypes.firstIndex(where: {$0.type == .paragraphCompletion})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        case 9 :
            secondLabel.text = "Anlam Bütünlüğü"
            let s = trackedTypes.firstIndex(where: {$0.type == .paragraphCompletion})
            if s != nil {
                let right = Float(trackedTypes[s!].right)
                let wrong = Float(trackedTypes[s!].wrong)
                label.text = "\(Int(CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 100))%"
                
                circleOneColorLayer.strokeEnd = CGFloat(CGFloat(right)/CGFloat(right + wrong)) * 0.8
            } else {
                 circleOneColorLayer.strokeEnd = 0
                label.text = "0%"
            }
        default:
            print("no")
        }
        
        
        
       
        secondLabel.font = UIFont(name: "Futura-Bold", size: 14)
        
        
        
        examSectionsView.layer.addSublayer(circleOneLayer)
        examSectionsView.layer.addSublayer(circleOneColorLayer)
        examSectionsView.addSubview(label)
        examSectionsView.addSubview(secondLabel)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





