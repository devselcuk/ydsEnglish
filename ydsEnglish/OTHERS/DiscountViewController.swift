//
//  DiscountViewController.swift
//  ydsEnglish
//
//  Created by çağrı on 2.06.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import SVProgressHUD

class DiscountViewController: UIViewController {
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     purchaseButton.layer.cornerRadius = 20
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func purchase(_ sender: UIButton) {
        SVProgressHUD.show()
        
        ProductDatabase.purchaseNonRenewable()
        
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
