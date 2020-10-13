

import UIKit
import ChameleonFramework
import FirebaseDatabase
import FirebaseAuth

class MessageDataViewController: UIViewController, LastSentMessage {
    var lastSentMessage =  ""
    
    var receiverName = ""
    
  
    var dataRef : DatabaseReference?
    
    
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var senders = [String]()
    
    var messagesDict = [String : [String]]()
    var myUserName = ""
    var snapsChildenCount = 0
    var firstAppeared = true
    
  let backgroundLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        dataRef = Database.database().reference()
        
        self.navigationItem.title = "MESSAGES"
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    
        
        myUserName = userDefaults.string(forKey: "username")!
        
        
            
         self.retrieveMessages()
        
        
   
      
        
        
        
       

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func editMessages(_ sender: UIBarButtonItem) {
        
        if messagesTableView.isEditing {
            messagesTableView.isEditing = false
            editButton.title = "Edit"
        } else {
            
            messagesTableView.isEditing = true
            editButton.title = "Done"
            
        }
        
        
        
    }
    
    
    
    
    var indexOfReturnedCell : Int?
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.senders.count == 0 {
            
            
            backgroundLabel.frame = self.messagesTableView.bounds
            self.messagesTableView.addSubview(backgroundLabel)
            backgroundLabel.text = "You haven't received any message yet"
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = UIColor.lightGray
            backgroundLabel.numberOfLines = 0
            backgroundLabel.font = UIFont(name: "Futura", size: 14)
            
            print("senddd")
            
            self.messagesTableView.separatorStyle = .none
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        var totalMessage = 0
        
        self.dataRef?.child("Messages").child(myUserName).observe(.childAdded, with: { (snap) in
            
         
            
          
            
            totalMessage +=  Int(snap.childrenCount)
            
            print("totalMessage")
            print(totalMessage)
            
            userDefaults.set(totalMessage, forKey: "totalMessage")
            
            
        })
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        var totalMessage = 0
        
        self.dataRef?.child("Messages").child(myUserName).observe(.childAdded, with: { (snap) in
            
            print("mysnap")
               print(snap)
            
            
            
           totalMessage +=  Int(snap.childrenCount)
            
            print("totalMessage")
            print(totalMessage)
            
           userDefaults.set(totalMessage, forKey: "totalMessage")
            
            
        })
        
        
        
       
        
        
        print(receiverName)
        print(lastSentMessage)
        
         indexOfReturnedCell = senders.firstIndex(of: receiverName)
        
       
        
        messagesTableView.reloadData()
        
        if firstAppeared == false {
           
            
            
            
           
            
            self.tabBarItem.badgeValue = "\(0)"
            self.tabBarItem.badgeColor = UIColor.clear
            
            
        } else {
            firstAppeared = false
            self.tabBarItem.badgeValue = "\(0)"
            self.tabBarItem.badgeColor = UIColor.clear
            
        }
        
        messagesTableView.reloadData()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 var index : Int?
}


extension MessageDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageDataCell") as! MessageDataTableViewCell
        
        cell.badgeLabel.layer.cornerRadius = 10
        
        cell.badgeLabel.backgroundColor = UIColor.flatMint()
        cell.badgeLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor.flatMint(), isFlat: true)
        
        cell.badgeLabel.clipsToBounds = true
       
        cell.badgeLabel.textAlignment = .center
     backgroundLabel.isHidden = true
        messagesTableView.separatorStyle = .singleLine
        
        
        cell.titleLabel.textColor = UIColor.darkText
        cell.titleLabel.font = UIFont(name: "Futura-Medium", size: 18)
        cell.titleLabel.text = senders[indexPath.row]
        cell.messageLabel.text = messagesDict[senders[indexPath.row]]?.last
        cell.messageLabel.textColor = UIColor.lightGray
        cell.messageLabel.font = UIFont(name: "Futura", size: 16)
     
        cell.pimageView.layer.cornerRadius = cell.pimageView.frame.height/2
        
        if indexOfReturnedCell != nil {
            if indexOfReturnedCell! == indexPath.row {
                cell.messageLabel.text = lastSentMessage
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondMessage" {
            let vc = segue.destination as! ChatViewController
            vc.hidesBottomBarWhenPushed = true
            vc.idOfReceiver = senders[index!]
            vc.navigationItem.title = senders[index!]
            vc.delegate = self
            
        }
    }
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        performSegue(withIdentifier: "secondMessage", sender: Any.self)
    }
    
    func retrieveMessages() {
        
        
        
        
        
        
        self.dataRef?.child("Messages").child(self.myUserName).observe(.childAdded, with: { (snap) in
            
            var mArray = [String]()
            
         
            
            for i in snap.children {
                
                
                if let m = i as? DataSnapshot {
    
                    if let string = m.value as? [String: String] {
                        if string["status"] == "active" {
                            
                            mArray.append(string["messageBody"]!)
                         
                        } else {
                          
                        }
                        
                       
                        
                        
                    }
                }
                
            }
            
        
            if mArray.count > 0 {
                
                self.messagesDict[snap.key] = mArray
                
                userDefaults.set(Int(snap.childrenCount), forKey: "\(snap.key)messageCount")
                self.snapsChildenCount += Int(snap.childrenCount)
                
                
                print("userDEFALYMESSAGECOUNT\(userDefaults.integer(forKey: "\(snap.key)messageCount"))")
                
                self.senders.append(snap.key)
                
                self.updateMessages()
                
                
                
                self.messagesTableView.reloadData()
            }
                
            
           
         
            
            
            
        })
    }
    
    
  
    
    
    
    func updateMessages() {
        
        for i in senders {
            print("printed i")
           print(i)
            dataRef?.child("Messages").child(myUserName).child(i).observe(.childAdded, with: { (snap) in
                print("came here")
                print(snap)
                if let newMessage = snap.value as? [String:String] {
                    
                    if newMessage["status"] == "active" {
                        self.messagesDict[i]?.append(newMessage["messageBody"]!)
                        
                        
                        self.messagesTableView.reloadData()
                        
                    }
                    
                    
                }
            })
            dataRef?.child("Messages").child(i).child(myUserName).observe(.childAdded, with: { (snap) in
                print("came here")
                print(snap)
                if let newMessage = snap.value as? [String:String] {
                    
                    if newMessage["status"] == "active" {
                        self.messagesDict[i]?.append(newMessage["messageBody"]!)
                        
                        
                        self.messagesTableView.reloadData()
                        
                        
                    }
                    
                }
            })
            
            
            
        }
        
        
    }
    
    
}


extension MessageDataViewController {
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           print(senders[indexPath.row])
           print(myUserName)
            
            
         let localSenders = senders
            
            dataRef?.child("Messages").child(localSenders[indexPath.row]).child(myUserName).observe(.childAdded, with: { (snap) in
                self.dataRef?.child("Messages").child(localSenders[indexPath.row]).child(self.myUserName).child(snap.key).updateChildValues(["status" : "deleted"])
            })
            
            
            dataRef?.child("Messages").child(myUserName).child(localSenders[indexPath.row]).observe(.childAdded, with: { (snap) in
                self.dataRef?.child("Messages").child(self.myUserName).child(localSenders[indexPath.row]).child(snap.key).updateChildValues(["status" : "deleted"])
            })
            
            
            senders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
    }
    
    
    
}
