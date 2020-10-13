//
//  TopicCardViewController.swift
//  DaysTableView
//
//  Created by çağrı on 21.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class TopicCardViewController: UIViewController {
  
    
    @IBOutlet var imageViews: [UIImageView]!
    
    @IBOutlet var labels: [UILabel]!
    
    
    @IBOutlet var cards: [UIView]!
  
    
    @IBOutlet weak var stackView: UIStackView!
    
    var backButton = UIButton()
    
    var selectedCard : UIView?
    
    var cardColors = [  UIColor]()
    
    let color1 = UIColor(displayP3Red: 161/255, green: 114/255, blue: 122/255, alpha: 1)
    let color2 = UIColor(displayP3Red: 166/255, green: 144/255, blue: 103/255, alpha: 1)
    let color3 = UIColor(displayP3Red: 43/255, green: 55/255, blue: 79/255, alpha: 1)
    let color4 = UIColor(displayP3Red: 105/255, green: 162/255, blue: 170/255, alpha: 1)
    let color5 = UIColor(displayP3Red: 103/255, green: 150/255, blue: 138/255, alpha: 1)
    let color6 = UIColor(displayP3Red: 135/255, green: 128/255, blue: 151/255, alpha: 1)



    override func viewDidLoad() {
        super.viewDidLoad()
         cardColors.append(color1)
          cardColors.append(color2)
          cardColors.append(color3)
          cardColors.append(color4)
          cardColors.append(color5)
          cardColors.append(color6)
        
      
        
        
        for card in cards {
            card.backgroundColor = UIColor.yellow
            card.layer.cornerRadius = 20
            card.clipsToBounds = true
        }
        
        for i in 0...5 {
            cards[i].backgroundColor = cardColors[i]
            cards[i].tag = i
            
        }
      
        
        addTaps()
        
        
       
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }
    
    
    
    
    var color : UIColor?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pSegue" {
            let vc = segue.destination as! ParagraphsViewController
            
          let card = sender as! UIView
            vc.color = cardColors[card.tag]
            print(sender.debugDescription)
            
            switch card.tag {
            case 0:
                vc.topic = "Economics"
            case 1:
                vc.topic = "History"
            case 2:
                vc.topic = "Culture"
            case 3:
                vc.topic = "Science"
            case 4:
                vc.topic = "Health"
            case 5:
                vc.topic = "Technology"
            default:
                print("noway")
            }
            
          
            
        }
    }

}



extension TopicCardViewController {
    
    
    func addTaps() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(turn))
    cards[0].addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(turn1))
        cards[1].addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(turn2))
        cards[2].addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(turn3))
        cards[3].addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(turn4))
        cards[4].addGestureRecognizer(tap4)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(turn5))
        cards[5].addGestureRecognizer(tap5)
        
        
        
        
    }
    
    
    
    @objc func turn() {
        
        performSegue(withIdentifier: "pSegue", sender: cards[0])
        
        
        
        
    }
    @objc func turn1() {
         performSegue(withIdentifier: "pSegue", sender: cards[1])
       
        
        
    }
    @objc func turn2() {
         performSegue(withIdentifier: "pSegue", sender: cards[2])
        
       
    }
    @objc func turn3() {
         performSegue(withIdentifier: "pSegue", sender: cards[3])
       
    }
    @objc func turn4() {
         performSegue(withIdentifier: "pSegue", sender: cards[4])
       
       
    }
    @objc func turn5() {
         performSegue(withIdentifier: "pSegue", sender: cards[5])
       
       
    }
    
    
    
    
   
    
    
}
