//
//  AnimateImageViewController.swift
//  cardView
//
//  Created by çağrı on 18.05.2019.
//  Copyright © 2019 çağrı. All rights reserved.
//

import UIKit
import FacebookCore

import TwitterKit

class AnimateImageViewController: UIViewController {
    
    
    @IBOutlet weak var leftLegImage: UIImageView!
    
    @IBOutlet weak var rightLegImage: UIImageView!
    
    @IBOutlet weak var leftHeartImage: UIImageView!
    @IBOutlet weak var rightHeartImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftLegImage.frame = CGRect(x: self.view.frame.width/2 - 90, y: -200, width: 100, height: 100)
        
        
        rightLegImage.frame = CGRect(x: self.view.frame.width , y: -200, width: 100, height: 100)
        
        leftHeartImage.frame = CGRect(x: self.view.frame.width/2 - 7.5, y: -200, width: 30, height: 30)
        
        rightHeartImage.frame = CGRect(x: self.view.frame.width/2 , y: -200, width: 30, height: 30)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leftLegImage.frame = CGRect(x: self.view.frame.width/2 - 180, y: -200, width: 100, height: 100)
        
        
        rightLegImage.frame = CGRect(x: self.view.frame.width + 100 , y: -200, width: 100, height: 100)
        
        leftHeartImage.frame = CGRect(x: self.view.frame.width/2 - 180, y: -200, width: 30, height: 30)
        
        rightHeartImage.frame = CGRect(x: self.view.frame.width/2 + 100 , y: -200, width: 30, height: 30)
        
        
       
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveLinear, animations: {
            
            self.leftLegImage.frame = CGRect(x: self.view.frame.width/2 - 100, y: self.view.frame.height/2 - 50, width: 100, height: 100)
            
            self.rightLegImage.frame = CGRect(x: self.view.frame.width/2 , y:self.view.frame.height/2 - 50, width: 100, height: 100)
            
        }) { (true) in
            
            UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveLinear, animations: {
                self.leftHeartImage.frame = CGRect(x: self.view.frame.width/2 - 20, y: self.view.frame.height/2 - 55, width: 30, height: 30)
                
                self.rightHeartImage.frame = CGRect(x: self.view.frame.width/2 - 12 , y: self.view.frame.height/2 - 55, width: 30, height: 30)
            }) {(true) in
               
                
                
                
                if  userDefaults.integer(forKey: "loggedIn") == 1 || AccessToken.current != nil  {
                  self.performSegue(withIdentifier: "alreadyLoggedIn", sender: Any.self)
                    
                  
                   
                } else {
                    self.performSegue(withIdentifier: "startWithLogin", sender: Any.self)
                }
                
                
                
            }
          
        }
        
        
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
