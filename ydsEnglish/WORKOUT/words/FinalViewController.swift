//
//  FinalViewController.swift
//  DaysTableView
//
//  Created by çağrı on 10.03.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {
    
    @IBOutlet var textViews: [UITextView]!
    @IBOutlet weak var progress: UIProgressView!
    
    var level : Int?
    var day : Int?
    
    var index = 0
    var secondindex = 0
   var  progressFloat : Float = 0
    
    @IBAction func next(_ sender: UIButton) {
        
        index += 1
        secondindex += 1
        
        progress.progress += (1 - progressFloat)/6
        
          userDefaults.set(progress.progress, forKey: "\(level!)\(day!)")
        
        
        
        if index == 6 {
            print("finished")
            performSegue(withIdentifier: "feedBack", sender: Any.self)
            
            return
        }
        
        
        
        
        
        var all = [firstFour, secondFour, thirdFour]
        if index > 2 {
            for i in textViews.indices {
                textViews[i].text = all[index - 3][i].englishMeaning
            }
        } else {
            for i in textViews.indices {
                textViews[i].text = all[index][i].turkishMeaning
            }
        }
       
        meaningData = []
        
        if secondindex == 3 {
            secondindex = 0
            
            
        }
        for i in 0...3 {
            meaningData.append(all[secondindex][i].word)
        }
      
        
        tableView1.reloadData()
        tableView2.reloadData()
        
    }
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    var imageViews = [ UIImageView]()
    let imageView = UIImageView()
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    
    var words = [EditedWords]()
    var edited = [EditedWords]()
    
    var firstFour = [EditedWords]()
     var secondFour = [EditedWords]()
    var thirdFour = [EditedWords]()
    
    var dragData = ["drag meaning here","drag meaning here","drag meaning here","drag meaning here"]
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedBack" {
            let vc = segue.destination as! FeedBackViewController
            let all = firstFour + secondFour + thirdFour
            var wordsToSend = [String]()
            for i in all {
                wordsToSend.append(i.word)
            }
            
            vc.words = wordsToSend
            
        }
    }
    
    
    
    
  
     var meaningData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.progress = progressFloat
       
        for i in words.indices {
            if i == 0 {
                edited.append(words[0])
            } else if edited.count < 12 {
                if words[i].word != words[i - 1].word {
                    edited.append(words[i])
                }
            } else if edited.count >= 12 {
                break
            }
        }
        
        for i in edited.indices {
            if i < 4 {
                firstFour.append(edited[i])
            } else if i > 3 && i < 8 {
                 secondFour.append(edited[i])
            } else {
                 thirdFour.append(edited[i])
            }
        }
        for i in 0...3 {
            meaningData.append(firstFour[i].word)
        }
        
        
        imageViews.append(imageView)
        imageViews.append(imageView1)
        imageViews.append(imageView2)
        imageViews.append(imageView3)
        
        
        for view in textViews {
            view.backgroundColor = UIColor(displayP3Red: 229/255, green: 131/255, blue: 86/255, alpha: 1)
            
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = false
            view.textAlignment = .center
            
        }
         var all = [firstFour, secondFour, thirdFour]
        for i in 0..<4 {
            textViews[i].tag = i
           
             textViews[i].text! = all[index][i].turkishMeaning
            textViews[i].font = UIFont(name: "Futura", size: 14)
            textViews[i].textColor = UIColor.white
            
            
          
            
            
            let dragger = UIDragInteraction(delegate: self)
            self.textViews[i].addInteraction(dragger)
            dragger.isEnabled = true
            
          
            
        }
        tableView2.dropDelegate = self
        for table in [tableView1,tableView2] {
            table?.delegate = self
            table?.dataSource = self
        }

    }
    
    @IBOutlet weak var stackView: UIStackView!
    
  let lemonDrop = UIColor(displayP3Red: 253/255, green: 235/255, blue: 116/255, alpha: 1)

}


extension FinalViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return dragData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "wordCell") as! TableViewCell
            
            
            cell.textLabel?.text = meaningData[indexPath.row]
            cell.textLabel?.textColor = UIColor.gray
            
            cell.backgroundColor = lemonDrop
            
            return cell
        } else {
            
            
            let cell1 = tableView2.dequeueReusableCell(withIdentifier: "meaningCell") as! WordMatchMeaningTableViewCell
            
            cell1.wordLabel.text = dragData[indexPath.row]
            cell1.wordLabel.textColor = UIColor.lightText
            cell1.wordLabel.backgroundColor = granite
          
            
            let imageViewFrame = CGRect(x: cell1.frame.minY, y: cell1.frame.minY, width: 30, height: 30)
          imageViews[indexPath.row].frame = imageViewFrame
            imageViews[indexPath.row].image = UIImage(named: "error")
            for view in imageViews {
                view.alpha = 0
            }
            cell1.addSubview(imageViews[indexPath.row])
        
            return cell1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableView1 {
            return tableView1.frame.height/4
        } else {
            return tableView2.frame.height/4
        }
        
    }
    
}




extension FinalViewController: UIDragInteractionDelegate, UITableViewDropDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let point = session.location(in: self.stackView)
        
        let n = stackView.hitTest(point, with: nil) as! UITextView
        
      
        let itemProvider = NSItemProvider(object: n.text as NSString)
            
            let item = UIDragItem(itemProvider: itemProvider)
        
      
     
        
            
        
        
        
                
         
      
        return [item]
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destIndexPath : IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destIndexPath = indexPath
        } else {
            let section = tableView2.numberOfSections - 1
            let row = tableView2.numberOfRows(inSection: section)
            destIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
            guard let stringArray = items as? [String] else { return}
          
        
            
            var all = [self.firstFour, self.secondFour, self.thirdFour]
            
            self.dragData.remove(at: self.dragData.count - 1)
           
           
            self.tableView2.deleteRows(at: [destIndexPath], with: .automatic)
           
            self.dragData.insert(stringArray.first!, at: destIndexPath.row)
           
           
            self.tableView2.insertRows(at: [destIndexPath], with: .automatic)
         
            let cell = self.tableView2.cellForRow(at: destIndexPath) as! WordMatchMeaningTableViewCell
            let cell1 = self.tableView1.cellForRow(at: destIndexPath)
            let indexOfWord = all[self.secondindex].firstIndex(where:{ $0.word == cell1?.textLabel?.text  })
            var indexOfMeaning = all[self.secondindex].firstIndex(where:{ $0.turkishMeaning == cell.wordLabel.text  })
            
            if self.index > 2 {
                indexOfMeaning = all[self.secondindex].firstIndex(where: {$0.englishMeaning == cell.wordLabel.text})
            }
            
            if indexOfWord == indexOfMeaning {
                cell.wordLabel.backgroundColor = self.lemonDrop
                cell.wordLabel.textColor = UIColor.gray
                
                
                cell1?.backgroundColor = self.lemonDrop
                cell1?.textLabel?.textColor = UIColor.gray
           
                
                
               self.imageViews[destIndexPath.row].alpha = 0
            
            } else {
             
                UIView.animate(withDuration: 1, animations: {
                    self.imageViews[destIndexPath.row].alpha = 1
                    self.imageViews[destIndexPath.row].frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    
                })
               
            }
            
           
        }
        
    
        
        
    }
    
    
    
    
    
    
}
