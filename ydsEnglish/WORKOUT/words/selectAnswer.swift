//
//  ext.swift
//  swipe
//
//  Created by çağrı on 29.11.2018.
//  Copyright © 2018 selcuk. All rights reserved.
//

import Foundation
import UIKit

extension WorkoutViewController  {
    
    
    
    
    func sentenceCompletion(i : Int) {
        
      
        
        let uncompleteSentence = wordMainLabel.text!
        let word = answerLabels[i].text
        var chr = ""
        for _ in word! {
            chr.append("_")
        }
        let completedSentence = uncompleteSentence.replacingOccurrences(of: chr, with: word!)
        
        for a in answerLabels {
            a.alpha = 1
        }
      
        
        for w in arrayFromSegue {
            let ws = w.sample.components(separatedBy: ".")
            for _ in ws {
                if uncompleteSentence != completedSentence && sentence.contains(answerLabels[i].text!) {
                  
                    points += 3
                    
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                        self.showPointsAnimationTextView.textColor = UIColor.flatWatermelon()
                        self.showPointsAnimationTextView.text = "+3 points"
                        self.showPointsAnimationTextView.isHidden = false
                        self.showPointsAnimationTextView.transform = CGAffineTransform(scaleX: 2, y: 2)
                    }) { (true) in
                        self.showPointsAnimationTextView.transform = .identity
                        self.showPointsAnimationTextView.isHidden = true
                    }
                    
                    
                    
                    trackWords(word: newArraytobeUsed[finalIndex!].word, right: true)
                    
                    pointsTextView.text = "\(points) pts"
                    userDefaults.set(points, forKey: "points")
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        self.shadowAnimation(label: self.answerLabels[i], color: UIColor.green)
                        self.answerLabels[i].center.y =  self.view1.center.y + self.wordMainLabel.frame.height/2 + self.answerLabels[i].frame.height/2
                        
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
                        
                        let range = (completedSentence as NSString).range(of: word!)
                        let attributedString = NSMutableAttributedString(string: completedSentence)
                        
                   attributedString.addAttribute(.obliqueness, value: 0.3, range: range)
                        
                 
                        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.grapefruit, range: range)
                        self.wordMainLabel.attributedText = attributedString
                    }
                    
                    
                    
                    return
                } else {
                    points -= 2
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                        self.showPointsAnimationTextView.textColor = UIColor.flatGray()
                        self.showPointsAnimationTextView.text = "-2 points"
                        self.showPointsAnimationTextView.isHidden = false
                        self.showPointsAnimationTextView.transform = CGAffineTransform(scaleX: 2, y: 2)
                    }) { (true) in
                        self.showPointsAnimationTextView.transform = .identity
                        self.showPointsAnimationTextView.isHidden = true
                    }
                   
                    pointsTextView.text = "\(points) pts"
                    userDefaults.set(points, forKey: "points")
                   
                    trackWords(word: newArraytobeUsed[finalIndex!].word, right: false)
                    shadowAnimation(label: answerLabels[i], color: UIColor.red)
                    return
                   
                }
            }
            
        }
        
        
        for label in answerLabels {
            label.isUserInteractionEnabled = false
        }
        
    }
    
    
    func shadowAnimation(label: UILabel, color : UIColor) {
        UIView.animate(withDuration: 0.3) {
            label.layer.shadowColor = color.cgColor
            label.layer.masksToBounds = false
            label.layer.shadowOffset = CGSize(width: -1, height: 1)
          label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            label.layer.shadowColor = UIColor.clear.cgColor
            
        }
        
        
    }
    
    
    
    func evaluateSelection(i : Int) {
        let words = wordsToBePointed.map({$0.word})
        print(words)
        if !words.contains(wordMainLabel.text!) {
            print("why here")
            wordsToBePointed.append(WordsWithPoint(word: wordMainLabel.text!, point: 0))
        }
        
        let indexOfEnglish = arrayFromSegue.firstIndex(where: { $0.englishMeaning == answerLabels[i].text })
        
        let indexOfTurkish = arrayFromSegue.firstIndex(where : {
            $0.turkishMeaning == answerLabels[i].text
        })
        
        
        if let a = indexOfEnglish {
            if  arrayFromSegue[a].word == wordMainLabel.text!  {
                   self.answerLabels[i].layoutIfNeeded()
                let index = wordsToBePointed.firstIndex(where : { $0.word == wordMainLabel.text!})
              
               
                wordsToBePointed[index!].point += 1
                
                let totalPoints = wordsToBePointed.map({$0.point})
                var x = 0
                for i in totalPoints {
                    x  += i
                }
                
                print(self.wordMainLabel.center.y)
                print(self.answerLabels[i].center.y)
                points += 1
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                    self.showPointsAnimationTextView.textColor = UIColor.flatWatermelon()
                    self.showPointsAnimationTextView.text = "+1 point"
                    self.showPointsAnimationTextView.isHidden = false
                    self.showPointsAnimationTextView.transform = CGAffineTransform(scaleX: 2, y: 2)
                }) { (true) in
                    self.showPointsAnimationTextView.transform = .identity
                    self.showPointsAnimationTextView.isHidden = true
                }
                
             
                pointsTextView.text = "\(points) pts"
                
                userDefaults.set(points, forKey: "points")
                
                print(view1.center.y)
                print(answerLabels[0].center.y)
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionFlipFromBottom, animations: {
                  
                    
                    
                    
                    self.shadowAnimation(label: self.answerLabels[i], color: UIColor.green)
                self.answerLabels[i].center.y = self.view1.frame.maxY - 10 + self.answerLabels[i].frame.height/2
                    
                })
                
            } else {
                
                self.shadowAnimation(label: self.answerLabels[i], color: UIColor.red)
            }
            print(view1.center.y)
            print(answerLabels[0].center.y)
        }
        
        if let b = indexOfTurkish {
            if  arrayFromSegue[b].word == wordMainLabel.text! {
                points += 2
                rightAnswer += 1
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                    self.showPointsAnimationTextView.textColor = UIColor.flatWatermelon()
                    self.showPointsAnimationTextView.text = "+2 points"
                    self.showPointsAnimationTextView.isHidden = false
                    self.showPointsAnimationTextView.transform = CGAffineTransform(scaleX: 2, y: 2)
                }) { (true) in
                    self.showPointsAnimationTextView.transform = .identity
                    self.showPointsAnimationTextView.isHidden = true
                }
                
                
                   trackWords(word: wordMainLabel.text!, right: true)
                
                
                pointsTextView.text = "\(points) pts"
                userDefaults.set(points, forKey: "points")
                
                
                userDefaults.set(rightAnswer, forKey: "rightWord")
                
                
                
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.shadowAnimation(label: self.answerLabels[i], color: UIColor.green)
           self.answerLabels[i].center.y = self.view1.frame.maxY - 10 + self.answerLabels[i].frame.height/2
                })
                
                
               
                
            } else {
                points -= 1
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .autoreverse, animations: {
                    self.showPointsAnimationTextView.textColor = UIColor.flatGray()
                    self.showPointsAnimationTextView.text = "-1 point"
                    self.showPointsAnimationTextView.isHidden = false
                    self.showPointsAnimationTextView.transform = CGAffineTransform(scaleX: 2, y: 2)
                }) { (true) in
                    self.showPointsAnimationTextView.transform = .identity
                    self.showPointsAnimationTextView.isHidden = true
                }
                
                 trackWords(word: wordMainLabel.text!, right: false)
                wrongAnswer += 1
                pointsTextView.text = "\(points) pts"
                userDefaults.set(points, forKey: "points")
                userDefaults.set(wrongAnswer, forKey: "wrongWord")
                self.shadowAnimation(label: self.answerLabels[i], color: UIColor.red)
            }
        }
    
        
       print(wordsToBePointed)
        
        for label in answerLabels {
            label.isUserInteractionEnabled = false
        }
        
        
    }

}
