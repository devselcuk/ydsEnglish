//
//  WorkoutViewController.swift
//  swipe
//
//  Created by çağrı on 24.11.2018.
//  Copyright © 2018 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase

let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = directory.appendingPathComponent("words").appendingPathExtension("plist")
let encoder = PropertyListEncoder()
let decoder = PropertyListDecoder()

class WorkoutViewController: UIViewController {
    @IBOutlet weak var wordMainLabel: UILabel!
   var index = 0
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var showPointsAnimationTextView: UITextView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var intFromSegue = 0
    var intFromSegueForColor : Int?
    var buttonTagCame : Int?
    
    
     var answerLabels: [UILabel]!
    
    var groupIndex = 0
    var rightAnswer = 0
    var wrongAnswer = 0
    
    var ref : DatabaseReference?
   
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func goBack(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "matching" {
            
            let mvc = segue.destination as! FinalViewController
           
            
            mvc.words = newArraytobeUsed
            mvc.progressFloat = progress.progress
            
            mvc.level = intFromSegueForColor!
            mvc.day = buttonTagCame!
            
            
        }
    }
    
    var wordMainLabelCenterX :CGFloat!
     var wordMainLabelCenterY :CGFloat!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let username = userDefaults.string(forKey: "username")
        ref?.child("currentUserPoints").child(username!).child("points").setValue(points)
        
        
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
  
        newLogicTwoDimension()
       
        
        emp = 1
        progress.progress += 1/Float(trackProgress)
        
        for label in answerLabels {
            label.isUserInteractionEnabled = true
        }
        
        userDefaults.set(progress.progress, forKey: "\(intFromSegueForColor!)\(buttonTagCame!)")
        
    
    }
    
  
    var points = 0
    
    @IBOutlet weak var pointsTextView: UITextView!
    var userDefaults = UserDefaults()
    
    var changeArrayInt = 0
    var chosenArray = [Int]()
    func setNewArray() {
        switch changeArrayInt {
        case 0:
            chosenArray = newArray0
        case 1 : chosenArray = newArray1
        case 2 : chosenArray = newArray2
        default : print("no way")
       
        }
        
        // repeating problem to be solved
      
        
        for i in chosenArray.indices {
            if i < chosenArray.count - 1{
             
                if chosenArray[i] == chosenArray[i + 1] {
                  
                    newInt = chosenArray[i] - chosenArray[0]
                    
                   
                    if newInt == 0 {
                        
                        firstArray.append(firstArray.last! + 1)
                        secondArray.append(secondArray.last! + 1)
                        thirdArray = [thirdArray[0] + 1]
                    
                        fourthArray.append(fourthArray.last! + 1)
                        fifthArray = [fifthArray[0] + 1]
                        sixthArray.append(sixthArray.last! + 1)
                        seventhArray.append(seventhArray.last! + 1)
                       
                        
                    }
                    if newInt == 1 {
                        
                        firstArray.append(firstArray.last! + 1)
                        secondArray.append(secondArray.last! + 1)
                        thirdArray = [thirdArray[0] + 1]
                     
                        fourthArray.append(fourthArray.last! + 1)
                        fifthArray = [fifthArray[0] + 1]
                        sixthArray.append(sixthArray.last! + 1)
                        seventhArray.append(seventhArray.last! + 1)
                      
                    }
                    if newInt == 2 {
                        thirdArray.append(thirdArray.last! + 1)
                
                        fourthArray.append(fourthArray.last! + 1)
                        fifthArray = [fifthArray[0] + 1]
                        sixthArray.append(sixthArray.last! + 1)
                        seventhArray.append(seventhArray.last! + 1)
                      
                    }
                    if newInt == 3 {
                     
                        fifthArray.append(fifthArray.last! + 1)
                        sixthArray.append(sixthArray.last! + 1)
                        seventhArray.append(seventhArray.last! + 1)
                
                    }
                    if newInt >= 4 {
                        fifthArray.append(fifthArray.last! + 1)
                        sixthArray.append(sixthArray.last! + 1)
                        seventhArray.append(seventhArray.last! + 1)
                     
                    }
                   
                    
                }
            }
        }
   
    
       changeArrayInt += 1
        if changeArrayInt > 2 {
            changeArrayInt = 0
        }
    }
    var newArraytobeUsed = [EditedWords]()
    var arrayFromSegue = [EditedWords]()
   
    @IBOutlet weak var view1: UIView!
    
    
    var wordsToBePointed = [WordsWithPoint]()
    
    var trackProgress = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPointsAnimationTextView.isHidden = true
        
    ref = Database.database().reference()
        
  points = userDefaults.integer(forKey: "points")
        
        pointsTextView.text = "\(points)"
        
        
        
        
        
        for i in arrayFromSegue.indices {
            if i >= intFromSegue {
                newArraytobeUsed.append(arrayFromSegue[i])
            }
        }
        
        solveSameWord()
        setNewArray()
       
    
      
        
        
       progress.progress = 0
        
        
        let t = newArray0.count + newArray1.count + newArray2.count
        let k = t - 12
        
        trackProgress = 51 + k*5 + 6
       
       view1.backgroundColor = UIColor.clear
        exitButton.backgroundColor = UIColor.clear
        exitButton.setTitleColor(UIColor.grapefruit, for: .normal)
        
        
        answerLabels = [label0,label1,label2,label3]
    
       newLogicTwoDimension()
       normalShape()
        
       
        nextButton.backgroundColor = cellButtonColors[intFromSegueForColor!]
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle("NEXT", for: .normal)
        
    self.view.backgroundColor = UIColor(displayP3Red: 222/255, green: 222/255, blue: 222/255, alpha: 1)

       print(newArray0.count)
        print(newArray1.count)
        print(newArray2.count)
        
     
        
        
        tapGesture0()
        tapGesture1()
        tapGesture2()
        tapGesture3()
        // Do any additional setup after loading the view.
    }
    
    var labelNum0 : Int?
     var labelNum1 : Int?
     var labelNum2 : Int?
     var labelNum3 : Int?
    var sameWordArray: [Int] = []
    var sameWordIdentity = 0
    var sameWordIndex = 0
    
    var newArray0 : [Int] = []
    var newArray1 : [Int] = []
    var newArray2 : [Int] = []
    var plusOne = 0
    var plusTwo = 0
     func solveSameWord() {
        for i in newArraytobeUsed.indices  {
            
            if sameWordIdentity < 12 && i < newArraytobeUsed.count {
                if sameWordIdentity < 4 {
                    newArray0.append(sameWordIdentity)
                }
                if sameWordIdentity == 4 {
                    plusOne = i
                }
                if sameWordIdentity == 8 {
                    plusTwo = i
                }
                if sameWordIdentity < 8 && sameWordIdentity > 3 {
                     newArray1.append(sameWordIdentity)
                }
                if  sameWordIdentity > 7 {
                    newArray2.append(sameWordIdentity)
                }
                 sameWordArray.append(sameWordIdentity)
            if newArraytobeUsed[sameWordIndex].word != newArraytobeUsed[sameWordIndex + 1].word {
                sameWordIdentity += 1
                
            }
                sameWordIndex += 1
               
            }
            
        }
        
    }
    
 
    var nextTour = 0
    
    var twoDimensionalArray : [[Int]] = []
    
    var finalIndex : Int?
    
    var firstArray = [0,1]
    var secondArray = [0,1]
    var thirdArray = [2]
    var fourthArray = [0,1,2]
    var fifthArray = [3]
    var sixthArray = [0,1,2,3]
    var seventhArray = [0,1,2,3]
    
    
    var newInt = 0
    var setPlus = 0
    
    func newLogicTwoDimension() {
        

        
        twoDimensionalArray = [firstArray,secondArray,thirdArray,fourthArray,fifthArray,sixthArray,seventhArray]
        
       
        
  
        if twoDimensionalArray[groupIndex].count  == index  {
           
            index = 0
          
            groupIndex += 1
        }
        
        if groupIndex == 7 {
            newInt = 0
        
            
            
            firstArray = [0,1]
            secondArray = [0,1]
            thirdArray = [2]
            fourthArray = [0,1,2]
            fifthArray = [3]
            sixthArray = [0,1,2,3]
            seventhArray = [0,1,2,3]
            
            
            setNewArray()
            
            if nextTour == 1 {
                setPlus = newArray0.count + newArray1.count
            } else {
                setPlus = newArray0.count
            }
           
            
            firstArray.enumerated().forEach { index, value in
                firstArray[index] = value + setPlus
            }
            secondArray.enumerated().forEach { index, value in
                secondArray[index] = value + setPlus
            }
            thirdArray.enumerated().forEach { index, value in
                thirdArray[index] = value + setPlus
            }
            fourthArray.enumerated().forEach { index, value in
                fourthArray[index] = value + setPlus
            }
            fifthArray.enumerated().forEach { index, value in
                fifthArray[index] = value + setPlus
            }
            sixthArray.enumerated().forEach { index, value in
                sixthArray[index] = value + setPlus
            }
            seventhArray.enumerated().forEach { index, value in
                seventhArray[index] = value + setPlus
            }
            
            
           
            
            
            twoDimensionalArray = [firstArray,secondArray,thirdArray,fourthArray,fifthArray,sixthArray,seventhArray]
            
          
            
            
            groupIndex = 0
            index = 0
            
            nextTour += 1
            
            if nextTour == 3 {
                performSegue(withIdentifier: "matching", sender: Any?.self)
            }
            
        }
       
        
        
       
        
         finalIndex  = twoDimensionalArray[groupIndex][index]
        
        
        
   
        
        
        if groupIndex == 0 {
            normalShape()
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
            
            answerLabels[0].text = newArraytobeUsed[finalIndex!].englishMeaning
            
            
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = true
            answerLabels[2].isHidden = true
            answerLabels[3].isHidden = true
            
        }  else if groupIndex == 1 {
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
        
           
            
            offf(n: 2)
            secondGen(n: 2)
            shuffleNums(n: 2)
            
            
          
            answerLabels[0].text = newArraytobeUsed[newNum0!].turkishMeaning
            answerLabels[1].text = newArraytobeUsed[newNum1!].turkishMeaning
           
            
           
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = false
            answerLabels[2].isHidden = true
            answerLabels[3].isHidden = true
        } else if groupIndex == 2 {
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
         
            answerLabels[0].text = newArraytobeUsed[finalIndex!].englishMeaning
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = true
            answerLabels[2].isHidden = true
            answerLabels[3].isHidden = true
        } else if groupIndex == 3 {
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
            offf(n: 3)
            secondGen(n: 3)
            shuffleNums(n: 3)
            answerLabels[0].text = newArraytobeUsed[newNum0!].turkishMeaning
            answerLabels[1].text = newArraytobeUsed[newNum1!].turkishMeaning
            answerLabels[2].text = newArraytobeUsed[newNum2!].turkishMeaning
        
            
            
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = false
            answerLabels[2].isHidden = false
            answerLabels[3].isHidden = true
        } else if groupIndex == 4 {
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
            
            answerLabels[0].text = newArraytobeUsed[finalIndex!].englishMeaning
            
            
            
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = true
            answerLabels[2].isHidden = true
            answerLabels[3].isHidden = true
        } else if groupIndex == 5 {
            wordMainLabel.text = newArraytobeUsed[finalIndex!].word
            
            offf(n: 4)
            secondGen(n: 4)
            shuffleNums(n: 4)
            answerLabels[0].text = newArraytobeUsed[newNum0!].turkishMeaning
            answerLabels[1].text = newArraytobeUsed[newNum1!].turkishMeaning
            answerLabels[2].text = newArraytobeUsed[newNum2!].turkishMeaning
            answerLabels[3].text = newArraytobeUsed[newNum3!].turkishMeaning
          
         
            
            
            
            
            answerLabels[0].isHidden = false
            answerLabels[1].isHidden = false
            answerLabels[2].isHidden = false
            answerLabels[3].isHidden = false
            
        } else if groupIndex == 6 {
            completeShape()
            
            var  emptyLine = ""
        sentenceFirst = newArraytobeUsed[finalIndex!].sample
            var sentences : [String] = sentenceFirst.components(separatedBy: ".")
             sentence = sentences[0]
            
            let word = newArraytobeUsed[finalIndex!].word
               optionsForSentences()
            
            shuffleNums(n : 4)
            answerLabels[0].text = newArraytobeUsed[newNum0!].word
            answerLabels[1].text = newArraytobeUsed[newNum1!].word
            answerLabels[2].text = newArraytobeUsed[newNum2!].word
            answerLabels[3].text = newArraytobeUsed[newNum3!].word
            // burdan
          
            
            let indexOfSentence = newArraytobeUsed.firstIndex(where: { $0.sample == sentenceFirst })
            let primitiveWord = newArraytobeUsed[indexOfSentence!].word
            var firstThreeLetters = ""
            var i = 0
            for ch in primitiveWord {
                i += 1
                if i < 4 {
                    firstThreeLetters.append(ch)
                }
            }
            var thisFinal = ""
            let wordsArray = sentence.split(separator: " ")
            
            for wrd in wordsArray {
                if  wrd.contains(firstThreeLetters) {
                    thisFinal = String(wrd)
                }
                
            }
            
            for ans in answerLabels {
                if ans.text! == word {
                    ans.text! = thisFinal
                }
            }
            
            // buraya kadar
            
            for _ in thisFinal {
                emptyLine.append("_")
            }
            
            let qSentence = sentence.replacingOccurrences(of: thisFinal, with: emptyLine)
            wordMainLabel.text = qSentence
            
        }
        
        
        index += 1
     
    
        
        
    }
    
    
    
    
    
    
    
    //tap gestures for textviews starts
    
    @objc func tapFunction0(sender: UITapGestureRecognizer) {
        if groupIndex != 6 {
            evaluateSelection(i: 0)
            
        }  else {
            sentenceCompletion(i: 0)
           
        }
        
        
       
       
       
    }
    
    func tapGesture0(){
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.tapFunction0))
        answerLabels[0].isUserInteractionEnabled = true
        answerLabels[0].addGestureRecognizer(tap)
      
    }
    @objc func tapFunction1(sender: UITapGestureRecognizer) {
        if groupIndex != 6 {
            evaluateSelection(i: 1)
        }  else {
            sentenceCompletion(i: 1)
        }
        
        if index == 1 && nextTour == 1 {
            sentenceCompletion(i: 1)
        }
       
    }
    
    func tapGesture1(){
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.tapFunction1))
        answerLabels[1].isUserInteractionEnabled = true
        answerLabels[1].addGestureRecognizer(tap)
        
    }
    @objc func tapFunction2(sender: UITapGestureRecognizer) {
        if groupIndex != 6 {
            evaluateSelection(i: 2)
        }  else {
            sentenceCompletion(i: 2)
        }
        
        
     
      
        
    }
    
    func tapGesture2(){
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.tapFunction2))
        answerLabels[2].isUserInteractionEnabled = true
        answerLabels[2].addGestureRecognizer(tap)
    }
    @objc func tapFunction3(sender: UITapGestureRecognizer) {
        if groupIndex != 6 {
            evaluateSelection(i: 3)
        }  else {
            sentenceCompletion(i: 3)
        }
        
        
      
        
    }
    
    func tapGesture3(){
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.tapFunction3))
        answerLabels[3].isUserInteractionEnabled = true
        answerLabels[3].addGestureRecognizer(tap)
     
    }
    
    //tap gestures for textviews ends
    
    var emp = 0
    
    
    // cümle tamamlama UI
    func completeShape() {
        wordMainLabel.layer.cornerRadius = 0
        wordMainLabel.backgroundColor = colors[intFromSegueForColor!]
        
        wordMainLabel.textColor = UIColor.white
        
        for label in answerLabels {
            label.layer.cornerRadius = 5
            label.backgroundColor = UIColor.clear
            label.textColor = colors[intFromSegueForColor!]
            label.layer.borderWidth = 1
            
        }
        
    }
    
   // kelime çalışması UI
    func normalShape() {
        for label in answerLabels {
            label.textColor = colors[intFromSegueForColor!]
            label.layer.cornerRadius = 20
            label.layer.maskedCorners = [.layerMaxXMaxYCorner]
            label.layer.borderWidth = 1
            label.layer.borderColor = colors[intFromSegueForColor!].cgColor
            label.textAlignment = .center
            label.numberOfLines = 0
            label.backgroundColor = UIColor.clear
            
        }
        
        
        
        
        wordMainLabel.layer.cornerRadius = 20
        wordMainLabel.backgroundColor = colors[intFromSegueForColor!]
        wordMainLabel.textAlignment = .center
        wordMainLabel.textColor = UIColor.white
        wordMainLabel.layer.borderColor = colors[intFromSegueForColor!].cgColor
        wordMainLabel.layer.borderWidth = 1
        
       
        wordMainLabel.numberOfLines = 0
        wordMainLabel.layer.maskedCorners = [ .layerMinXMinYCorner]
        
        
        wordMainLabel.clipsToBounds = true
    }
    
    var sentence = String()
    var sentenceFirst = String()
    
    // Şıklardaki sorunları çöz
    
    
    
    var newNum0 : Int?
    var newNum1 : Int?
    var newNum2 : Int?
    var newNum3 : Int?
    var sameWordInt = 0
    func secondGen(n : Int) {
 
       
        newNum0 = mustBeIndex
       
        if sameWordInt == 1  {
            newNum0! += 1
        } else if sameWordInt == 2 {
            newNum0! += 2
        }
        
        
        if groupIndex < 6 {
        if wordMainLabel.text! == newArraytobeUsed[finalIndex! + 1].word {
       
          
            sameWordInt += 1
        } else {
            sameWordInt = 0
        }
        } else {
            
            
        }
      
            
            
            var generatedNumber = Int.random(in: canBeNumbers.indices)
            newNum1 = canBeNumbers[generatedNumber]
            
            canBeNumbers = canBeNumbers.filter({$0 != newNum1!})
            
          
             generatedNumber = Int.random(in: canBeNumbers.indices)
            newNum2 = canBeNumbers[generatedNumber]
         
            
            canBeNumbers = canBeNumbers.filter({$0 != newNum2!})
            
         
            generatedNumber = Int.random(in: canBeNumbers.indices)
            newNum3 = canBeNumbers[generatedNumber]
        
        if chosenArray == newArray1 {
            newNum0! += newArray0.count
            newNum1! += newArray0.count
            newNum2! += newArray0.count
            newNum3! += newArray0.count
        }
        if chosenArray == newArray2 {
            newNum0! += newArray0.count + newArray1.count
            newNum1! += newArray0.count + newArray1.count
            newNum2! += newArray0.count + newArray1.count
            newNum3! += newArray0.count + newArray1.count
        }
            
        
     
       

 
    }
     var canBeNumbers = [Int]()
    var mustBeIndex : Int?
    var latestIndex = Int()
    func offf (n : Int) {
          canBeNumbers = []
      
        
        
        mustBeIndex = newArraytobeUsed.firstIndex(where: { $0.word == wordMainLabel.text!})
        if mustBeIndex == nil {
            mustBeIndex = newArraytobeUsed.firstIndex(where: { $0.sample == sentenceFirst})
          
        }
     
        
        if chosenArray[0] == 4 {
           
            mustBeIndex! = mustBeIndex! - newArray0.count
        } else if chosenArray[0] == 8 {
            mustBeIndex! = mustBeIndex! - newArray0.count - newArray1.count
        }
        
        latestIndex = chosenArray[mustBeIndex!]
           
      
        
        
        
        for i in chosenArray.indices {
            if chosenArray[i] != latestIndex {
                canBeNumbers.append(i)
            }
            
          
            
            
        }
        
        
    }
    var sentenceOptionArray = [Int]()
    func optionsForSentences () {
        sentenceOptionArray = []
        
        mustBeIndex = newArraytobeUsed.firstIndex(where: { $0.sample == sentenceFirst})
        
       
        
        if chosenArray[0] == 4 {
            mustBeIndex! = mustBeIndex! - newArray0.count
        } else if chosenArray[0] == 8 {
            mustBeIndex! = mustBeIndex! - newArray0.count - newArray1.count
        }
        sentenceOptionArray.append(0)
 
        for i in 0..<chosenArray.count - 1 {
           
            if chosenArray[i] != chosenArray[i + 1] {
                sentenceOptionArray.append(i + 1)
            }
       
        }
       
        
        newNum0 = sentenceOptionArray[0]
        newNum1 = sentenceOptionArray[1]
        newNum2 = sentenceOptionArray[2]
        newNum3 = sentenceOptionArray[3]
        
        if chosenArray == newArray1 {
            newNum0! += newArray0.count
            newNum1! += newArray0.count
            newNum2! += newArray0.count
            newNum3! += newArray0.count
        }
        if chosenArray == newArray2 {
            newNum0! += newArray0.count + newArray1.count
            newNum1! += newArray0.count + newArray1.count
            newNum2! += newArray0.count + newArray1.count
            newNum3! += newArray0.count + newArray1.count
        }
    
        
        
        
    }
    
    func shuffleNums (n : Int) {
        var newArrayForNums = [Int]()
        var arrayForSet = [newNum0, newNum1, newNum2, newNum3]
        
        
        
        for i in 0..<n {
            newArrayForNums.append(arrayForSet[i]!)
        }
        

        
        newArrayForNums.shuffle()
        
        newNum0 = newArrayForNums[0]
        newNum1 = newArrayForNums[1]
        
        if n > 2 {
            newNum2 = newArrayForNums[2]
        }
     
        if n > 3 {
            newNum3 = newArrayForNums[3]
        }
        
        
    
        
        
    }
    
    
  
}

extension UIColor {
    convenience  init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "invalid red component")
        assert(green >= 0 && green <= 255, "invalid green component")
        assert(blue >= 0 && blue <= 255, "invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0 , blue: CGFloat(blue) / 255.0, alpha : 1.0 )
    }
    
    
    convenience init(rgb: Int) {
        self.init(
            red : (rgb >> 16) & 0xFF,
            green : (rgb >> 16) & 0xFF,
            blue : (rgb >> 16) & 0xFF
        )
    }
}
extension UIColor {
    
    static let olivegreen = UIColor(red: 0x4b, green: 0x74, blue: 0x47)
    static let carrot = UIColor(red: 0xee, green: 0x69, blue: 0x3f)
    
    static let blueberry = UIColor(red: 0x4d, green: 0x64, blue: 0x8d)
    static let tangerine = UIColor(red: 0xf6, green: 0x94, blue: 0x54)
    static let grapefruit = UIColor(red: 0xfa, green: 0x81, blue: 0x25)
}




