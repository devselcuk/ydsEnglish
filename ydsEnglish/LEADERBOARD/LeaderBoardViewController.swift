//
//  LeaderBoardViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 6.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

struct NameAndPoints : Equatable {
    var username : String
    var points : Int
    static func > (lhs: NameAndPoints, rhs : NameAndPoints) -> Bool {
        return lhs.points > rhs.points
        
    }
}



class LeaderBoardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myProfilePic: UIImageView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var myQueueLabel: UILabel!
    
    
    var ref : DatabaseReference?
     let layer = CAGradientLayer()
    var profileData = [String]()
    var imageData = [String : Data]()
    
    var nameAndPoints = [NameAndPoints]()
    
    
    var storage : StorageReference?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMessage" {
            let vc = segue.destination as! ChatViewController
           let button = sender as? UIButton
        
            vc.idOfReceiver = nameAndPoints[button!.tag].username
            
            vc.navigationItem.title = nameAndPoints[button!.tag].username
            
            
        }
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "sendMessage", sender: sender)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationItem.title = userDefaults.string(forKey: "username")
        pointsLabel.text = "\(userDefaults.integer(forKey: "points"))"
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = Storage.storage().reference()
        
        self.navigationItem.title = userDefaults.string(forKey: "username")
         pointsLabel.text = "\(userDefaults.integer(forKey: "points"))"
        
        
        
      
      
     
       myProfilePic.layer.cornerRadius = 50
        myProfilePic.isUserInteractionEnabled = true
        
        let profilePic = userDefaults.data(forKey: "proPic")
        
        
        if profilePic != nil {
            myProfilePic.image = UIImage(data: profilePic!)
        }
        
        layer.colors = [UIColor(displayP3Red: 104/255, green: 171/255, blue: 231/255, alpha: 1).cgColor, UIColor(displayP3Red: 97/255, green: 109/255, blue: 172/255, alpha: 1).cgColor ]
        
    
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)

        layer.frame = topView.bounds
        layer.masksToBounds = false
        

        
        topView.layer.insertSublayer(layer, at: 0)

        
        
       
        
        topView.layer.shadowOffset = CGSize(width: 5, height: 5)
     
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 0.5
        
        
        topView.clipsToBounds = true
        topView.layer.masksToBounds = false
        topView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        topView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.layer.cornerRadius = 20
    
        
        
    tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        
        ref?.child("currentUserPoints").observe(.value, with: { (snap) in
            print(snap)
            
            self.nameAndPoints = []
          
            if let data = snap.value as? [String : [String : Int]] {
                
                print("data")
                print(data)
                
                
                
                let nameArray = Array(data.keys)
                
                
                let pointsArray = Array(data.values)
                
               
                for i in nameArray.indices {
                 
                    self.nameAndPoints.append(NameAndPoints(username: nameArray[i], points: pointsArray[i]["points"]!))
                    
                    self.nameAndPoints.sort(by: >)
                    
                    
                    
                    if i < 100 {
                        
                        self.storage?.child("profilePics").child(nameArray[i]).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("loading error")
                                print(error!)
                                return
                            }
                            self.imageData[nameArray[i]] = data!
                            print("data")
                            print(nameArray[i])
                            print(self.imageData)
                            print(data!)
                            self.tableView.reloadData()
                            
                        })
                        
                    }
                }
                
                
                self.tableView.reloadData()
                
            }
            
        

            
        })
        
        
   
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    override func viewDidLayoutSubviews() {
        layer.frame = topView.bounds
    }
    
}



extension LeaderBoardViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameAndPoints.count > 100 {
            return 100
        } else {
            
          return nameAndPoints.count
        }
        
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        cell.messageButton.tag = indexPath.row
        cell.profilePicture.contentMode = .scaleToFill
        
       cell.profilePicture.image = UIImage(named: "newMan")
        cell.profilePicture.layer.cornerRadius = 30
        
        
        
        cell.nameLabel.text = nameAndPoints[indexPath.row].username
        cell.pointsLabel.text = "\(nameAndPoints[indexPath.row].points) points"
    
        cell.nameLabel.textColor = UIColor.flatSkyBlue()
        cell.pointsLabel.textColor = UIColor(complementaryFlatColorOf: cell.nameLabel.textColor)
        
        if let data = self.imageData["\(cell.nameLabel.text!)"] {
            cell.profilePicture.image = UIImage(data: data)
        }
        
        
        let myQue = nameAndPoints.firstIndex(where: {$0.username ==  userDefaults.string(forKey: "username")})
        if myQue != nil {
            myQueueLabel.text = "\(myQue! + 1)"
        } else {
           myQueueLabel.text = "N/A"
        }
       
        
        
        
        cell.numLabel.text = "\(indexPath.row + 1)"
        
      
       
        return cell
    }
    
    
    
}
