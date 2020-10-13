//
//  ChatViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 29.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ChameleonFramework



struct Message : Equatable {
    var messageBody : String
    var senderName : String
    var receiverName : String
    var time : Date
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.time < rhs.time
    }
    
    
}

protocol LastSentMessage {
    var lastSentMessage : String {  get  set}
    var receiverName : String {get set }
}

class ChatViewController: UIViewController {
   
    
    var delegate : LastSentMessage?
    
  
    
    var dataRef : DatabaseReference?
    
    
    @IBOutlet weak var keyBoardView: UIView!
    
    @IBOutlet weak var heightConstOfKeyBoardView: NSLayoutConstraint!
    
    @IBOutlet var navBar: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    var idOfReceiver : String?
    var myUserName : String?
    
    var messageArray = [Message]()
    
   
    
    @IBOutlet weak var messageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        dataRef = Database.database().reference()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.estimatedRowHeight = 250
        
        messageTableView.rowHeight =  UITableView.automaticDimension
        
        messageTableView.separatorStyle = .none
        
        myUserName = userDefaults.string(forKey: "username")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.retrieveMessages()
        }
       

        messageTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        messageTextField.layer.borderColor = UIColor.white.cgColor
        messageTextField.clipsToBounds = true
        messageTextField.layer.borderWidth = 0.5
        messageTextField.layer.cornerRadius = 25
        messageTextField.placeholder = "Type your message here"
        // Do any additional setup after loading the view.
    }
    
    var seen = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      seen += 1
        
        if seen == 5 {
            seen = 0
        }
        
       
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
    
        
        
        let date = Date()
        let calender = Calendar.current
        
        var dateComponents = DateComponents()
        
        dateComponents.year = calender.component(.year, from: date)
        dateComponents.day =  calender.component(.day, from: date)
        dateComponents.hour = calender.component(.hour, from: date)
        dateComponents.minute = calender.component(.minute, from: date)
        dateComponents.second = calender.component(.second, from: date)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        
        let now = calender.date(from: dateComponents)
        
        
        
        
        
        
        
      
        dataRef?.child("Messages").child(idOfReceiver!).child(myUserName!).childByAutoId().setValue(["messageBody" : self.messageTextField.text! , "time" : "\(now!)", "status":"active"])
        
        
       
        
         messageTextField.endEditing(true)
        messageTextField.text = ""
        heightConstOfKeyBoardView.constant = 60
        self.scrollToBottom()
        self.view.layoutIfNeeded()
       

        
    }
    
    
   
 
    func retrieveMessages() {
       
        
        dataRef?.child("Messages").child(self.idOfReceiver!).child(self.myUserName!).observe(.childAdded, with: { (snap) in
            
            
            
                if let message = snap.value as? [String:String] {
                    
                 
                                        let newMessage = message["messageBody"]
                    let timeString = message["time"]
                    let status = message["status"]
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "UTC")
                    dateFormatter.timeZone = TimeZone(identifier:  "UTC")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +s"
                    
                    let now =  dateFormatter.date(from: timeString!)
                    
                    
                    if status == "active" {
                        
                        self.messageArray.append(Message(messageBody: newMessage!, senderName: self.myUserName!, receiverName: self.idOfReceiver!, time: now!))
                        
                        
                        self.delegate?.lastSentMessage = self.messageArray.last!.messageBody
                        self.delegate?.receiverName = self.idOfReceiver!
                        
                        
                        self.messageArray.sort(by: <)
                        self.messageTableView.reloadData()
                        
                        
                        self.scrollToBottom()
                    }
 
                    
                    
                    
                }
           
            
            
    

           
        })
        
        
        
        
        dataRef?.child("Messages").child(self.myUserName!).child(self.idOfReceiver!).observe(.childAdded, with: { (snap) in
            
            
            
                if let message = snap.value as? [String:String] {
                    
                
                    let newMessage = message["messageBody"]
                    let timeString = message["time"]
                    let status = message["status"]
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "UTC")
                    dateFormatter.timeZone = TimeZone(identifier:  "UTC")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +s"
                    
                    let now =  dateFormatter.date(from: timeString!)
                    
                    if status == "active" {
                        self.messageArray.append(Message(messageBody: newMessage!, senderName: self.idOfReceiver! , receiverName: self.myUserName!, time: now!))
                        
                        self.delegate?.lastSentMessage = self.messageArray.last!.messageBody
                        self.delegate?.receiverName = self.idOfReceiver!
                        
                        self.messageArray.sort(by: <)
                        self.messageTableView.reloadData()
                        
                    }
                    
                    
                   //scroll to bottom
                    self.scrollToBottom()
                    
                }
            
            
            
            
            
            
        })
        

        
        
        
        
        

    }
    
    
    func scrollToBottom() {
        
        if self.messageArray.count > 0 {
            let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
            
            self.messageTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            
        }
        
        
    }
    
    

}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func convertTimeAsString(dateString:String) -> String {

        let subStrings = dateString.split(separator: " ")
      let hourwithSeconds = subStrings[1]
        let secondSub = hourwithSeconds.split(separator: ":")
        let hourWithMins = "\(secondSub[0]):\(secondSub[1])"
        return hourWithMins
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageTableViewCell
        
        cell.cellView.layer.cornerRadius = 35
        cell.cellView.clipsToBounds = true
           cell.messageLabel.backgroundColor = UIColor.clear
        
        let timeString = "\(messageArray[indexPath.row].time)"
        cell.timeLabel.text = convertTimeAsString(dateString: timeString)
        
        
        
       
        
      
        if messageArray[indexPath.row].senderName == idOfReceiver! {
            cell.cellViewLeadingConst.constant = 5
            cell.cellViewTrailingConst.constant = 75
           cell.cellView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            
            
         
            cell.messageLabel.textColor = UIColor.darkText
            print(cell.messageLabel.frame.width)
            print("first")
          
            print("second")
             print(cell.messageLabel.frame.width)
            
            cell.cellView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
           cell.timeLabel.textColor = UIColor.gray
            
        } else {
            cell.cellViewLeadingConst.constant = 75
            cell.cellViewTrailingConst.constant = 5
            cell.cellView.backgroundColor = blueSky
            
            cell.messageLabel.textColor = UIColor.white
            cell.cellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.timeLabel.textColor = UIColor.lightText
            
        }
          cell.isUserInteractionEnabled = false
        cell.messageLabel.text = messageArray[indexPath.row].messageBody
        
        cell.cellView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConst = NSLayoutConstraint(item: cell.cellView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 70)
        
        cell.cellView.addConstraint(heightConst)
        
        
        return cell
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.5) {
                self.heightConstOfKeyBoardView.constant = keyboardRectangle.height + keyboardRectangle.height * 0.15
             self.scrollToBottom()
                self.view.layoutIfNeeded()
            }
            
        }
    
    
    
}
    
    
    
    
    
    
    
}
