//
//  ProductDatabase.swift
//  ydsEnglish
//
//  Created by çağrı on 16.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import SwiftyStoreKit
import SVProgressHUD

// Mock data source for available `Product`s in this demo app.
// Often, an app will not need anything more complicated than a simple provider like this.
// If your app uses a freemium business model, for example, your product model could vend `Product` instances alongside associated data about the upgrades to present in the user interface.

var hasValidPurchase = [Bool]()


public enum ProductDatabase {
    
  public static let sharedSecret = "c684fd987ffc460ab32d1a89758f112c"
    
  public static  let oneMonthId = "ccc.ydsEnglish.PremiumOneMonth"
    
    public static let threeMonthsId = "ccc.ydsEnglish.PremiumThreeMonth"
    
    public static let oneYearId = "ccc.ydsEnglish.PremiumContentOneYear"
    
    public static let nonRenewableOneMonth = "ccc.ydsEnglish.TryOneMonth"
    
 
    
    
    // All of the possible products available in the app. This sequence will be passed to the `Merchant.register(...)` method.
   
    
    
    
    
    // Providing localized names without going to the server (using `Purchase.localizedTitle` or similar) means you can provide the names of products without requiring a network load.
    // This tactic is recommended, although you probably want a slightly more sophisticated method than this simple switch statement. Loading the names of a pro subscription could reside in a Localizable.strings resource, for example.
    
    public static func purchase(productId: String )  {
        
      
        
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            
            
            if let product = result.retrievedProducts.first {
                
                print("product\(product) ")
                print(product.localizedDescription)
                
                
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    
                    SVProgressHUD.dismiss()
                    SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
                        switch result {
                        case .success(let product):
                            
                            // fetch content from your server, then:
                            if product.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(product.transaction)
                            }
                            
                            print("Purchase Success: \(product.productId)")
                            switch productId {
                            case oneMonthId:
                                userDefaults.set(true, forKey: "purchase\(1)")
                            case threeMonthsId :
                                userDefaults.set(true, forKey: "purchase\(3)")
                            case oneYearId :
                                userDefaults.set(true, forKey: "purchase\(12)")
                            case nonRenewableOneMonth :
                                userDefaults.set(true, forKey: "try\(1)")
                            default:
                                print("noid")
                            }
                            
                            
                            
                        case .error(let error):
                           
                            switch error.code {
                            case .unknown: print("Unknown error. Please contact support")
                            case .clientInvalid: print("Not allowed to make the payment")
                            case .paymentCancelled: break
                            case .paymentInvalid: print("The purchase identifier was invalid")
                            case .paymentNotAllowed: print("The device is not allowed to make the payment")
                            case .storeProductNotAvailable: print("The product is not available in the current storefront")
                            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                            case .privacyAcknowledgementRequired:
                                print("privacyAcknowledgementRequired")
                            case .unauthorizedRequestData:
                                print("unauthorizedRequestData")
                            case .invalidOfferIdentifier:
                                 print("invalidOfferIdentifier")
                            case .invalidSignature:
                                 print("invalidSignature")
                            case .missingOfferParams:
                                 print("missingOfferParams")
                            case .invalidOfferPrice:
                                print("invalidOfferPrice")
                            @unknown default:
                                print("default")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    public static func purchaseNonRenewable() {
        SwiftyStoreKit.purchaseProduct(nonRenewableOneMonth, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                SVProgressHUD.dismiss()
                
                print("Purchase Success: \(purchase.productId)")
                userDefaults.set(true, forKey: "try\(1)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
    }
   
    
    
    public static func restorePurchases() {
        
        
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                print("Restore Success: \(results.restoredPurchases)")
                 
                
                verifySubscription(id: oneMonthId)
                verifySubscription(id: threeMonthsId)
                verifySubscription(id: oneYearId)
                verifySubscription(id: nonRenewableOneMonth)
               
            }
            else {
                print("Nothing to Restore")
            }
        }
        
    }
    
    
    
   
    
    public static func retrieveProducts(productId : String) {
    
    
    SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
    if let product = result.retrievedProducts.first {
    let priceString = product.localizedPrice!
        pricesToUpdate.append(priceString)
   
    print(priceString)
    }
    else if let invalidProductId = result.invalidProductIDs.first {
    print("Invalid product identifier: \(invalidProductId)")
    }
    else {
    print("Error: \(String(describing: result.error))")
    }
    }
    

    }
    
    
    public static func verifySubscription(id : String) {
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
    SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
    switch result {
    case .success(let receipt):
    let productId = id
    // Verify the purchase of a Subscription
    let purchaseResult = SwiftyStoreKit.verifySubscription(
    ofType: .autoRenewable, // or .nonRenewing (see below)
    productId: productId,
    inReceipt: receipt)
    
    switch purchaseResult {
    case .purchased(let expiryDate, let items):
    
    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
    
    switch id {
    case oneMonthId:
       userDefaults.set(true, forKey: "purchase\(1)")
    case threeMonthsId :
         userDefaults.set(true, forKey: "purchase\(3)")
    case oneYearId :
         userDefaults.set(true, forKey: "purchase\(12)")
    case nonRenewableOneMonth :
       userDefaults.set(true, forKey: "try\(1)")
    default:
        print("noid")
        }
    
    
    case .expired(let expiryDate, let items):

    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
        
    switch id {
    case oneMonthId:
        userDefaults.set(false, forKey: "purchase\(1)")
    case threeMonthsId :
        userDefaults.set(false, forKey: "purchase\(3)")
    case oneYearId :
        userDefaults.set(false, forKey: "purchase\(12)")
    case nonRenewableOneMonth :
        userDefaults.set(false, forKey: "try\(1)")
    default:
        print("noid")
        }
    case .notPurchased:
  
    print("The user has never purchased \(productId)")
    }
    
    case .error(let error):
   
    print("Receipt verification failed: \(error)")
    }
    }
    }
    
}
