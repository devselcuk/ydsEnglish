//
//  ViewController.swift
//  DaysTableView
//
//  Created by çağrı on 4.03.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct ExpandedRows {
    var isOpened : Bool
    var rowsData : [String]
    
    
}
class MyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableData = [ExpandedRows]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData[section].isOpened {
            
            return tableData[section].rowsData.count
        } else {
          
            return 0
        }
        
       
        
       
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.layer.cornerRadius = 10
        
        
        cell.textLabel?.text = tableData[indexPath.section].rowsData[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.red
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    @IBAction func act(_ sender: UIButton) {
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        
        sectionView.backgroundColor = UIColor.white
        
        
        
        let newView = UIView()
        
        newView.frame = CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 100)
        newView.layer.shadowOffset = CGSize(width: -5, height: 5)
        newView.clipsToBounds = false
        newView.layer.shadowColor = UIColor.gray.cgColor
        newView.layer.shadowOpacity = 0.3
        newView.layer.shadowRadius = 3
        newView.layer.cornerRadius = 10
        newView.backgroundColor = colors[levelInt!]
        
        let label = UILabel()
        label.frame = CGRect(x: tableView.frame.width/2 - 50, y: 5, width: 100, height: 20)
        label.text = "Day \(section + 1)"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 20)
        label.backgroundColor = UIColor.clear
        
        let label1 = UILabel()
        label1.frame = CGRect(x: tableView.frame.width/2 - 100, y: 25, width: 200, height: 20)
        label1.text = "12 Words"
        label1.textColor = UIColor.lightText
        label1.textAlignment = .center
        label1.font = UIFont(name: "Arial", size: 15)
        label1.backgroundColor = UIColor.clear
        let progressBar = UIProgressView()
        
        progressBar.frame = CGRect(x: 20, y: 50, width: tableView.frame.width - 60, height: 2)
        progressBar.progressTintColor = cellButtonColors[levelInt!]
        
        progressBar.trackTintColor = UIColor.lightGray
        let progressInt = userDefaults.float(forKey: "\(levelInt!)\(section)")
        
        progressBar.setProgress(progressInt, animated: true)
        
        let button1 = UIButton(type: .system)
        button1.frame = CGRect(x: tableView.frame.width/2 - 100, y: 60, width: 200, height: 30)
        button1.layer.cornerRadius = 15
 
      
        button1.backgroundColor = cellButtonColors[levelInt!]
       
       
        button1.addTarget(self, action: #selector(startLearning), for: .touchUpInside)
        button1.setTitle("Start Learning", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)") || userDefaults.bool(forKey: "try\(1)") {
            
        } else {
            if section > 2 {
                button1.setImage(UIImage(named: "lock"), for: .normal)
                button1.tintColor = UIColor.flatBlack()
                button1.imageEdgeInsets = UIEdgeInsets(top: 5, left: -40, bottom: 5, right: 0)
            }
        }
       
        
       
        
        
        button1.tag = section
        
    
        
        
        
        let starView = UIImageView()
        
        starView.frame = CGRect(x: newView.frame.width - 30, y: 5, width: 20, height: 20)
        starView.contentMode = .scaleToFill
        
        starView.image = UIImage(named: "star")
        
        
        let starView1 = UIImageView()
        
        starView1.frame = CGRect(x: newView.frame.width - 60, y: 5, width: 20, height: 20)
        starView1.contentMode = .scaleToFill
        
        starView1.image = UIImage(named: "star")
        
        let starView2 = UIImageView()
        
        starView2.frame = CGRect(x: newView.frame.width - 90, y: 5, width: 20, height: 20)
        starView2.contentMode = .scaleToFill
        
        starView2.image = UIImage(named: "star")
        
        
        
        
        
        
        
        
        
        
        
         let button = UIButton(type: .system)
        
        button.frame = CGRect(x: tableView.frame.width - 50, y: 60, width: 25, height: 25)
        button.backgroundColor = newView.backgroundColor
        button.setBackgroundImage(UIImage(named: "down"), for: .normal)
        button.addTarget(self, action: #selector(handle), for: .touchUpInside)
        button.tag = section
        newView.addSubview(button1)
        newView.addSubview(progressBar)
        newView.addSubview(label1)
        newView.addSubview(label)
        newView.addSubview(starView)
        if levelInt! == 1 {
            newView.addSubview(starView1)
        }
        if levelInt! == 2 {
            newView.addSubview(starView1)
            newView.addSubview(starView2)
            
        }
        
        sectionView.addSubview(newView)
 newView.addSubview(button)
        
       
        
       return sectionView
    }
    
    var intsToPassViaSegue = [Int]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "learningSegue" {
            let vc = segue.destination as! WorkoutViewController
            let button = sender as? UIButton
            vc.intFromSegue = intsToPassViaSegue[button!.tag]
            vc.arrayFromSegue = arrayFromSegue
            vc.intFromSegueForColor = levelInt!
            vc.buttonTagCame = button!.tag
            
            print(button!.tag)
        }
    }
    
    @objc func startLearning (button : UIButton) {
        
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)") || userDefaults.bool(forKey: "try\(1)") {
              performSegue(withIdentifier: "learningSegue", sender: button)
        } else {
            if button.tag < 3 {
                  performSegue(withIdentifier: "learningSegue", sender: button)
            }
            else {
               performSegue(withIdentifier: "purchaseFromW", sender: button)
            }
        }
        
      
       
    }
    
    @objc func handle(button: UIButton) {
        
        
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)") || userDefaults.bool(forKey: "try\(1)") {
            if tableData[button.tag].isOpened {
                tableData[button.tag].isOpened = false
            } else {
                tableData[button.tag].isOpened = true
                
            }
        } else {
            if button.tag < 3 {
                if tableData[button.tag].isOpened {
                    tableData[button.tag].isOpened = false
                } else {
                    tableData[button.tag].isOpened = true
                    
                }
            } else {
               performSegue(withIdentifier: "purchaseFromW", sender: button)
            }
        }
        
      
        
     
        // Update your data source here
       
        
        tableView.reloadSections([button.tag], with: UITableView.RowAnimation.fade)
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var wordsForOneDay = [[String]]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
        if userDefaults.bool(forKey: "inAppPurchaseShowed") && !userDefaults.bool(forKey: "discountShowedUp") {
            performSegue(withIdentifier: "discount", sender: Any.self)
            userDefaults.set(true, forKey: "discountShowedUp")
        }
        
        
    }
    
    var arrayFromSegue = [EditedWords]()
    var levelInt : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
       
        
        
        var smallArray = [String]()
        var index = 0
        var count = 0
      
        
        for i in arrayFromSegue.indices {
            if i < arrayFromSegue.count - 1 {
               
                if i == 0 {
                    intsToPassViaSegue.append(i)
                }
                if count == 12 {
                    
                     intsToPassViaSegue.append(i)
                    count = 0
                    index += 1
                    wordsForOneDay.append(smallArray)
                    smallArray = [String]()
                }
                
            if arrayFromSegue[i].word != arrayFromSegue[i+1].word {
                
                smallArray.append(arrayFromSegue[i].word)
               
                count += 1
                
            }
         
            }
            
        }
        
        for i in wordsForOneDay.indices {
            tableData.append(ExpandedRows(isOpened: false, rowsData: wordsForOneDay[i]))
        }
 
        tableView.backgroundColor = UIColor.white
        
        tableView.delegate =  self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

