//
//  InAppPurchaseViewController.swift
//  cardView
//
//  Created by çağrı on 15.05.2019.
//  Copyright © 2019 çağrı. All rights reserved.
//

import UIKit
import SVProgressHUD
import SafariServices
class InAppPurchaseViewController: UIViewController {
    
    @IBOutlet var purchaseViews: [UIView]!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
       userDefaults.set(true, forKey: "inAppPurchaseShowed")
        
        
    }
    
    @IBOutlet var totalPrices: [UILabel]!
    
    @IBOutlet var monthlyPrices: [UILabel]!
    
    var purchaseInt = 1
    @IBAction func purchase(_ sender: UIButton) {
        print(purchaseInt)
        switch purchaseInt {
        case 0:
         choose1()
        case 1 :
           choose2()
        case 2 :
           choose3()
        default:
            print("no selecetion")
           
        }
        
        
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for v in purchaseViews {
            v.layer.cornerRadius = 10
            v.backgroundColor = UIColor.white
            v.isUserInteractionEnabled = true
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(choose1))
        
        purchaseViews[0].addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(choose2))
        
        purchaseViews[1].addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(choose3))
        
        purchaseViews[2].addGestureRecognizer(tap3)
        
        
        purchaseViews[1].backgroundColor = dismissButton.backgroundColor
        
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        
        purchaseButton.layer.cornerRadius = purchaseButton.frame.height/2
        restoreButton.layer.cornerRadius = restoreButton.frame.height/2
        
        
    }
    
    
    @IBAction func restorePurchases(_ sender: UIButton) {
     
    ProductDatabase.restorePurchases()
 
        // Do any additional setup after loading the view.
    }
    
    
    @objc func choose1() {
        for v in purchaseViews {
            v.backgroundColor = UIColor.white
        }
        purchaseInt = 0
        SVProgressHUD.show()
        
        ProductDatabase.purchase(productId: ProductDatabase.oneMonthId)
        
        purchaseViews[0].backgroundColor = dismissButton.backgroundColor
        
    }
    
    @objc func choose2() {
        for v in purchaseViews {
            v.backgroundColor = UIColor.white
        }
         SVProgressHUD.show()
        purchaseInt = 1
        ProductDatabase.purchase(productId: ProductDatabase.threeMonthsId)
        
       
        
        purchaseViews[1].backgroundColor = dismissButton.backgroundColor
        
    }
    
    @objc func choose3() {
        for v in purchaseViews {
            v.backgroundColor = UIColor.white
        }
        purchaseInt = 2
         SVProgressHUD.show()
        ProductDatabase.purchase(productId: ProductDatabase.oneYearId)
        purchaseViews[2].backgroundColor = dismissButton.backgroundColor
        
    }
    
    
    
    
    @IBAction func policy(_ sender: UIButton) {
        let url = URL(string: "https://www.freeprivacypolicy.com/privacy/view/ae9ac8e1703cf7ec52fe10320f63b9f4")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func terms(_ sender: UIButton) {
        
        let url = URL(string: "https://app.termly.io/document/terms-of-use-for-website/25266497-52d5-4bab-ba61-63e8aa48b10a")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    

}
