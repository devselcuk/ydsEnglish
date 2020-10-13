//
//  loginMountainViewController.swift
//  animationS
//
//  Created by çağrı on 2.03.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SVProgressHUD
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit


let userDefaults = UserDefaults()

class loginMountainViewController: UIViewController, LoginButtonDelegate {
    
     let facebookButton = LoginButton(readPermissions: [ .publicProfile ])
   
    
    
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBAction func loginWithTwitter(_ sender: UIButton) {
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            print("does come here")
            
            if session != nil {
                print("signed in as \(session!.userName)");
               
                
                
                
                let credential = TwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret)
                
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    
                    userDefaults.set(session!.userName, forKey: "username")
                    
                    userDefaults.set(1, forKey: "loggedIn")
                    self.ref!.child("usernames").child(Auth.auth().currentUser!.uid).setValue(["username":session!.userName])
                    self.performSegue(withIdentifier: "login", sender: Any.self)
                }
                

                
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        
        
    }
    
    
    
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled :
            print("cancelled")
        case .success( _, _, let accessToken) :
            print("dd")
            let request = GraphRequest(graphPath: "me", parameters: ["Fields" : "email,name"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: .defaultVersion)
            request.start { (connection, result) in
             
                
                switch result {
                case .success( let response):
                   let info = response.dictionaryValue!
                    let username = info["name"]
                   
                   
                   
                   
                   let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                   
                   
                 
                

                   
                   Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                    if let error = error {
                        print("Facebook authentication with Firebase error: ", error)
                        return
                    }
                    print("User signed in!")
                    
                    self.ref!.child("usernames").child(Auth.auth().currentUser!.uid).setValue(["username":username])
                    
                    
                    userDefaults.setValue(username, forKey: "username")
                    self.performSegue(withIdentifier: "login", sender: Any.self)
                    
                    // After this line the Facebook login should appear on your Firebase console
                   }
                   
                   
                   
                    
                default :
                    print("default")
                    
                }
                
            }
      
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logout")
    }
    
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var whyUserNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signButton: UIButton!
    
    var ref : DatabaseReference?
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var isShowSignUpPage = true
    
    @IBOutlet weak var formView: UIView!
    
    @IBAction func showLogin(_ sender: UIButton) {
        if isShowSignUpPage {
           
            UIView.transition(with: formView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { (true) in
                self.loginButton.setTitle("LOG IN", for: .normal)
                self.signButton.setTitle("Henüz hesabın yok mu? Kayıt Ol", for: .normal)
                 self.isShowSignUpPage = false
                
            }
            
        } else {
          
            UIView.transition(with: formView, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { (true) in
                self.loginButton.setTitle("SIGN UP", for: .normal)
                self.signButton.setTitle("Zaten bir hesabın var mı? Giriş Yap", for: .normal)
                
                  self.isShowSignUpPage = true
                
            }
            
            
        }
        
    }
    
    
    
    
    @IBAction func login(_ sender: UIButton) {
        
        if isShowSignUpPage {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                if error != nil {
                let alert = UIAlertController(title: error?.localizedDescription, message: "Lütfen Tekrar Deneyin!", preferredStyle: .alert)
                    
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    print(error!)
                } else {
                  self.usernameView.isHidden = false
                    SVProgressHUD.dismiss()
                    self.ref!.child("usernames").observe(.childAdded) { (snap) in
                        if let allUsernames = snap.value as? [String: Any] {
                            let username = allUsernames["username"] as? String ?? ""
                            print(username)
                            
                            
                            
                            self.userNames.append(username)
                        }
                    }
                }
            }
        } else {
            
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authresult, error) in
                if error != nil {
                  
                    
                    
                    
                    let alert = UIAlertController(title: error?.localizedDescription, message: "Lütfen Tekrar Deneyin!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    print(error!)
                }  else {
                    let id = Auth.auth().currentUser?.uid
                    self.ref?.child("usernames").child(id!).observe(.value, with: { (snap) in
                       
                        if let nameDict = snap.value as? [String : String] {
                            
                            let myName = nameDict["username"] ?? ""
                            
                            userDefaults.set(myName, forKey: "username")
                            userDefaults.set(1, forKey: "loggedIn")
                            SVProgressHUD.dismiss()
                            
                            self.performSegue(withIdentifier: "login", sender: Any.self)
                        }
                        
                      
                        
                    })
                    
                  
                }
            }
        }
        
        
        
        
        getUser()
    }
    
    func getUser() {
        
        
    }
    
    
    
    @IBAction func done(_ sender: UIButton) {
       
        self.view.bringSubviewToFront(usernameView)
    
        
        if usernameTextField.text == "" {
            let x = UIAlertController(title: "Kullanıcı Adı", message: "Lütfen Bir Kullanıcı Adı Yazınız", preferredStyle: .alert)
           
            let action = UIAlertAction(title: "Anladım", style: .cancel, handler: nil)
            x.addAction(action)
            
            self.present(x, animated: true, completion: nil)
            return
            
            
            
        }
        
        ref!.child("usernames").child(Auth.auth().currentUser!.uid).setValue(["username":usernameTextField.text]) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            
            
            userDefaults.set(self.usernameTextField.text!, forKey: "username")
            
            userDefaults.set(1, forKey: "loggedIn")
           
             self.performSegue(withIdentifier: "login", sender: Any.self)
        }
        
        
        
        
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        facebookButton.delegate = self
        usernameTextField.delegate = self
        
        ref = Database.database().reference()
      
        
        self.view.bringSubviewToFront(usernameView)
        usernameView.isHidden = true
        
       userImageView.layer.cornerRadius = 25
        usernameView.layer.cornerRadius = 20
       
        whyUserNameLabel.numberOfLines = 0
        whyUserNameLabel.textAlignment = .center
        
      
        doneButton.layer.cornerRadius = 5
        doneButton.setTitle("KAYDET", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 17)
        
       loginButton.backgroundColor = UIColor(displayP3Red: 64/255, green: 118/255, blue: 115/255, alpha: 1)
          doneButton.backgroundColor = loginButton.backgroundColor
        
       loginButton.layer.cornerRadius = 25
        email.attributedPlaceholder = NSAttributedString(string: "e-mail", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
        
          usernameTextField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.textColor = usernameView.backgroundColor
        
       
        
    
        
        
         password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
        
        email.layer.cornerRadius = 25
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.lightText.cgColor
        
        password.layer.cornerRadius = 25
        
            password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.lightText.cgColor
        
    
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let centerY = twitterButton.frame.maxY + 30
        
        facebookButton.center = CGPoint(x: self.view.center.x, y: centerY)
        

        
        self.view.addSubview(facebookButton)
        print("facebookButton")
        print(facebookButton.frame)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
var userNames = [String]()
}


extension loginMountainViewController: UITextFieldDelegate {
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let x = textField.text!
        print(x)
        var typed = textField.text! + string
        print(typed)
        
        
        if typed.count == textField.text?.count {
            
            typed = String(typed.dropLast())
        }
        print(typed)
        print("after")
        print(x)
        
        
        let sbl = userNames.filter { ($0 == typed)
        }
        
        if sbl.count > 0 {
            
            
            
            for s in sbl {
                if s == typed {
                    textField.attributedPlaceholder = NSAttributedString(string: "Bu kullanıcı adı kullanılmaktadır.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                    
                    
                    
                   doneButton.isEnabled = false
                    doneButton.setTitleColor(UIColor.lightGray, for: .disabled)
                    print("usernametaken")
                } else {
                   
                    
                }
            }
        } else {
            doneButton.isEnabled = true
            
            textField.placeholder = "Kullanıcı Adı"
        }
        
        
       return true
    }
    

    
}
