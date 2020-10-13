//
//  SettingsViewController.swift
//  cardView
//
//  Created by çağrı on 17.05.2019.
//  Copyright © 2019 çağrı. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseAuth
import FacebookLogin
import TwitterKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    let loginManager = LoginManager()
    
    
    
    @IBAction func logOut(_ sender: UIButton) {
        
        
        do {
            try Auth.auth().signOut()
            loginManager.logOut()
            let store = TWTRTwitter.sharedInstance().sessionStore
            
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
            }
            
            userDefaults.set(0, forKey: "loggedIn")
            performSegue(withIdentifier: "secondLogout", sender: Any.self)
            
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
  stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func aboutUs(_ sender: UIButton) {
        
        let url = URL(string: "http://kocsys.com/hakkimizda/")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicy(_ sender: UIButton) {
        let url = URL(string: "https://www.freeprivacypolicy.com/privacy/view/ae9ac8e1703cf7ec52fe10320f63b9f4")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func termsOfService(_ sender: UIButton) {
        let url = URL(string: "https://app.termly.io/document/terms-of-use-for-website/25266497-52d5-4bab-ba61-63e8aa48b10a")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
        
        
        
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
