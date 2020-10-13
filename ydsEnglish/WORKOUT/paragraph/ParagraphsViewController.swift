//
//  ParagraphsViewController.swift
//  DaysTableView
//
//  Created by çağrı on 22.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD

struct TitleAndAuthor {
    var title : String
    var author : String
}

class ParagraphsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityCoverView: UIView!
    
    @IBOutlet weak var warningLabel: UILabel!
    var passageCount = 0
    var fetchedImages = [UIImage]()
    
    var color : UIColor?
    var topic : String?
    
    var savedParaWordsURL : URL?
    
    
    var titleAndAuthor = [TitleAndAuthor]()
    
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
 
    
    var storageRef = Storage.storage().reference()
    var dataRef = Database.database().reference()
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        
        
        activityIndicator.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
         self.warningLabel.isHidden = true
        print(color.debugDescription)
        activityCoverView.backgroundColor = color
        self.view.bringSubviewToFront(activityCoverView)
        
       
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: {
            if self.activityCoverView.isHidden == false {
                
                self.warningLabel.isHidden = false
            }
        })
        
        
       
        dataRef.child("Paragraphs").child(topic!).observe(.value) { (snap) in
            
           
            self.passageCount = Int(snap.childrenCount)
            
         
            print(self.passageCount)
           
            
            
            for i in 0..<self.passageCount {
            
                self.dataRef.child("Paragraphs").child(self.topic!).child("article\(i+1)").observe(.value, with: { (childSnap) in
                    if let data = childSnap.value as? [String:String] {
                        let author = data["author"] ?? ""
                        let title = data["title"] ?? ""
                        
                        self.titleAndAuthor.append(TitleAndAuthor(title: title, author: author))
                        
                        print(self.titleAndAuthor)
                        print("first here?")
                        
                        
                    }
                })
                
   
                self.storageRef.child("\(self.topic!)\(i+1).jpg").getData(maxSize: 4096*4096) { (data, error) in
                    print("yeeee")
                    if error != nil {
                       
                       print(error!)
                        return
                    }
                    
                    if let image = UIImage(data: data!) {
                        print("data")
                        self.fetchedImages.append(image)
                    }
                    if i == self.passageCount - 1{
                        self.tableView.reloadData()
                        self.activityCoverView.isHidden = true
                      SVProgressHUD.dismiss()
                    }
                
                }
                
                
            }
        }
      
    
        
        
      

        
 
        
     /*  activityIndicator.startAnimating()
        storageRef.child("paraPics").getData(maxSize: 4096*4096) { (data, error) in
            print("here")
            print("dataaa")
           
            
            if error != nil {
                print(error!)
                print("check your internet connection")
                
            }
            
            if let dataPic = data {
                if let image = UIImage(data: dataPic) {
                    print(image)
                }
            } else {
                print("nodata")
            }
           
              
                
               
         
             
            
            
        
            
          
        } */
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
   
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var indexOfCell : Int?

}

extension ParagraphsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pCell") as! ParagraphTableViewCell
        cell.backgroundColor = color!
        
        cell.titleLabel.textColor = cell.backgroundColor!
        tableView.backgroundColor = cell.backgroundColor!
        cell.cellView.backgroundColor = UIColor.white
        cell.paraPic.image = fetchedImages[indexPath.row]
        cell.authorLabel.textColor = UIColor.lightGray
        
        print(fetchedImages.count)
        print(titleAndAuthor)
        
        cell.titleLabel.text = titleAndAuthor[indexPath.row].title
        cell.authorLabel.text = titleAndAuthor[indexPath.row].author
        
        
        
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)") || userDefaults.bool(forKey: "try\(1)") {
           
        } else {
            if indexPath.row == 0 {
          
            } else {
                cell.lockPic.image = UIImage(named: "lock")
            }
        }
       
        
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showP" {
            let vc = segue.destination as! ParagraphViewController
            vc.color = color!
            vc.paragrafInt = indexOfCell! + 1
            vc.topic = topic
            vc.titleImage = self.fetchedImages[indexOfCell!]
          
         
            
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       indexOfCell = indexPath.row
      
        if userDefaults.bool(forKey: "purchase\(1)") || userDefaults.bool(forKey: "purchase\(3)") || userDefaults.bool(forKey: "purchase\(12)"){
            
            performSegue(withIdentifier: "showP", sender: ParagraphTableViewCell())
            
        } else {
            if indexPath.row == 0 {
                 performSegue(withIdentifier: "showP", sender: ParagraphTableViewCell())
            } else {
                performSegue(withIdentifier: "purchaseFromP", sender: Any.self)
            }
        }
        
    }
    
    
 
    
    
    
}
