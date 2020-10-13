//
//  ChooseGameViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 9.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD



var globalGameId : String?




class ChooseGameViewController: UIViewController  {
  
    
    
    @IBOutlet weak var coverView: UIView!
    
    
    
    
    
    @IBOutlet weak var startButton: UIButton!
    
    
    
    var ref : DatabaseReference?
    var myUserName : String?
    var opponentUserName : String?
    var iAmStarter : Bool?
    var gameId : String?
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(userDefaults.bool(forKey: "purchase"))
        
        guard userDefaults.bool(forKey: "purchase\(1)") == false else { return}
        guard userDefaults.bool(forKey: "purchase\(3)") == false else { return}
        guard userDefaults.bool(forKey: "purchase\(12)") == false else { return}
        
        
     
        
        
        
    }
    
    
    @IBAction func dismissCover(_ sender: UIButton) {
        
        if gameId != nil {
            ref?.child("Game").child(gameId!).child(myUserName!).setValue(["status":"closed"])
            ref?.child("Game").removeAllObservers()
        }
        coverView.isHidden = true
        SVProgressHUD.dismiss()
    }
    
    
    
    @IBAction func randomOpponent(_ sender: UIButton) {
        
        coverView.isHidden = false
        SVProgressHUD.show()
        self.ref?.child("Game").childByAutoId().child(self.myUserName!).setValue(["status":"Ready", "opponent":"random"])
        
       
       
        
        
        
        
        ref?.child("Game").observe(.value, with: { (snap) in
            
            for child in snap.children {
                
               
            
                
                if let childSnap = child as? DataSnapshot {
                    
                
                    if let nameSnap = childSnap.value as? [String : [String:String]] {
                    
                        let a = Array(nameSnap.keys)
                        let value = nameSnap[a[0]]
                        
                        let status = value!["status"]
                      print("\(a[0]) is equal to \(self.myUserName!) ")
                        if a[0] != self.myUserName {
                            
                            
                            if status == "Ready" {
                                self.ref?.child("Game").child(childSnap.key).child(a[0]).setValue(["status":"Started", "opponent":self.myUserName])
                                
                                self.gameId = childSnap.key
                                globalGameId = childSnap.key
                                
                                self.opponentUserName = a[0]
                               
                                
                                self.iAmStarter = false
                               
                                
                                
                                
                                return
                                
                                
                            } else {
                                print("started")
                            }
                            
                            
                            
                        } else {
                            
                            self.gameId = childSnap.key
                            globalGameId = childSnap.key
                            
                            print("status \(status!)")
                            if status == "Started" {
                                self.ref?.child("Game").child(childSnap.key).child(a[0]).setValue(["status":"Closed", "opponent":self.myUserName])
                            
                                
                                self.opponentUserName = value!["opponent"]
                                
                                self.iAmStarter = true
                                self.ref?.child("Game").removeAllObservers()
                                self.coverView.isHidden = true
                                SVProgressHUD.dismiss()
                                self.performSegue(withIdentifier: "game", sender: Any.self)
                            }
                            
                            
                        }
                       
                      
                       
                      
                        
                    }
               
                    
                }
            }
        })
        
        
        
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "game" {
            let vc = segue.destination as! QuizViewController
            
            vc.opponentUserName = self.opponentUserName!
            vc.myUserName = myUserName!
            vc.iAmStarter = iAmStarter!
            vc.gameId = gameId!
           
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        coverView.isHidden = true
        myUserName = userDefaults.string(forKey: "username")
        
        ref = Database.database().reference()
        
        startButton.layer.cornerRadius = 75
        

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
        if gameId != nil {
            print(gameId!)
            print(myUserName!)
          ref?.child("Game").child(gameId!).child(myUserName!).setValue(["status":"closed"])
        }
        
        ref?.child("Game").removeAllObservers()
        coverView.isHidden = true
        SVProgressHUD.dismiss()
        
        
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
