//
//  ExamMenuViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 4.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD


class ExamMenuViewController: UIViewController, ProgressedInt {
    var progressInt = 0
    
    var examNum = 0
    
   
    @IBOutlet weak var backgroundImageView: UIImageView!
    
   
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference?
    
  
    var examCount = 0
    
    
    var index : Int?
    
    
    var questionQuantity = [Int]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(progressInt)
        print(examNum)
        
       tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
        
        
        ref = Database.database().reference()
        
        SVProgressHUD.show()
        
        
        
        ref?.child("Exams").observe(.value, with: { (snap) in
            self.examCount = Int(snap.childrenCount)
            
            userDefaults.set(self.examCount, forKey: "examCount")
            
            print("adnasndnand")
         
            
            for child in snap.children {
                if let data = child as? DataSnapshot {
                    let x = data.childrenCount
                    print(x)
                    self.questionQuantity.append(Int(x))
                    
                }
            }
            
            
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
        
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
       
        tableView.backgroundColor = UIColor.flatPurple()?.withAlphaComponent(0.7)
        self.view.bringSubviewToFront(tableView)
        
        
        
        

    }
    
  
   

}

extension ExamMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "examMenuCell") as! TableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        
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
        newView.backgroundColor = UIColor(displayP3Red: 241/255, green: 241/255, blue: 242/255, alpha: 1)
        
        let label = UILabel()
        label.frame = CGRect(x: tableView.frame.width/2 - 50, y: 5, width: 100, height: 20)
        label.text = "Exam \(indexPath.row + 1)"
        label.textColor = UIColor(displayP3Red: 68/255, green: 147/255, blue: 170/255, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 20)
        label.backgroundColor = UIColor.clear
        
        let label1 = UILabel()
        label1.frame = CGRect(x: tableView.frame.width/2 - 100, y: 25, width: 200, height: 20)
       
        label1.textColor = UIColor.lightGray
        label1.textAlignment = .center
        var label1Text = ""
        if questionQuantity[indexPath.row] == 1 {
            label1Text = "Question"
        } else {
            label1Text = "Questions"
        }
        
        label1.text = "\(questionQuantity[indexPath.row]) \(label1Text)"
        label1.font = UIFont(name: "Arial", size: 15)
        label1.backgroundColor = UIColor.clear
        let progressBar = UIProgressView()
        
        progressBar.frame = CGRect(x: 20, y: 50, width: tableView.frame.width - 60, height: 2)
        progressBar.progressTintColor = cellButtonColors[0]
        
        progressBar.trackTintColor = UIColor.lightGray
        let progressInt = userDefaults.float(forKey: "vggg")
        
        progressBar.setProgress(progressInt, animated: true)
        
        let button1 = UIButton(type: .system)
        button1.frame = CGRect(x: tableView.frame.width/2 - 100, y: 60, width: 200, height: 30)
        button1.layer.cornerRadius = 15
        
        
        button1.backgroundColor = UIColor(displayP3Red: 68/255, green: 147/255, blue: 170/255, alpha: 1)
        
        
       
        button1.setTitle("Start Exam", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        
        button1.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        
        
        
        
        button1.tag = indexPath.row
        
        
        
        
        
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
        
        
        
        
        
        
        
        
        
        
        
       
        newView.addSubview(button1)
        newView.addSubview(progressBar)
        newView.addSubview(label1)
        newView.addSubview(label)
        cell.contentView.addSubview(newView)
       
        
        
        if indexPath.row ==  examNum {
            print("does it come")
            print(Float(Float(progressInt)/Float(10)))
            print(progressInt)
            
           progressBar.progress = Float(Float(progressInt)/Float(10))
            
        }
       
       
        
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exam" {
            let vc = segue.destination as! DrawViewController
            vc.examNum = index!
            vc.delegate = self
            
            
        }
    }
    
    
    @objc func handleTap(button: UIButton) {
        
        index = button.tag
        
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)") || userDefaults.bool(forKey: "try\(1)"){
              performSegue(withIdentifier: "exam", sender: Any.self)
        } else {
            if button.tag == 0 {
                  performSegue(withIdentifier: "exam", sender: Any.self)
            } else {
                  performSegue(withIdentifier: "purchaseFromE", sender: Any.self)
            }
            
            
        }
        
        
        
    }
    
    
 
    
    
    
    
    
    
    
}



