//
//  ViewController.swift
//  SwipingViews
//
//  Created by çağrı on 2.03.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth


let colors = [UIColor(displayP3Red: 192/255, green: 97/255, blue: 91/255, alpha: 1), UIColor(displayP3Red: 75/255, green: 110/255, blue: 132/255, alpha: 1),UIColor(displayP3Red: 75/255, green: 110/255, blue: 132/255, alpha: 1)]

let cellButtonColors = [UIColor(displayP3Red: 69/255, green: 75/255, blue: 90/255, alpha: 1), UIColor(displayP3Red: 237/255, green: 147/255, blue: 107/255, alpha: 1),UIColor(displayP3Red: 213/255, green: 176/255, blue: 102/255, alpha: 1)]
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    let imageNames = ["beginner","intermediate","advanced"]
    let levels = ["Beginner Level", "Intermediate Level", "Advanced Level"]
    var senderTag : Int?
    @IBAction func cellButtonNext(_ sender: UIButton) {
        print("sendertaggg")
        print(sender.tag)
        senderTag = sender.tag
        performSegue(withIdentifier: "levelSegue", sender: UIButton())
        
        let uid = Auth.auth().currentUser?.uid
        print("\(uid!)  my uidddd")
        
       
        ref.child("userPoints").child(uid!).setValue(["thisUsersPoint" : senderTag!, "id" : uid!])
        
      
    }
   
    
    let grades = ["YDS notu 50 altında olanlar için tavsiye edilir.","YDS notu 50 - 75 arasında olanlar için tavsiye edilir.","YDS notu 75 üzerinde olanlar için tavsiye edilir."]
    
    let countsLabelText = ["Son 5 yıl içerisinde YDS'de çıkmış 600 basit kelime","Son 5 yıl içerisinde YDS'de çıkmış 700 orta seviye kelime","Son 5 yıl içerisinde YDS'de çıkmış 200 ileri düzey kelime"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellScaling : CGFloat = 0.6
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    var ref : DatabaseReference!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "levelSegue" {
            print("nicee")
            print(senderTag!)
            let vc = segue.destination as! MyTableViewController
                vc.levelInt = senderTag!
                switch senderTag {
                case 0 :  vc.arrayFromSegue = allWords
                    
                case  1 : vc.arrayFromSegue = allWords1
                default :  vc.arrayFromSegue = allWords2
                    
                }
           
            
           
        }
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        
       
        
        
    }
    
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        cell.gradeLabel.textColor = UIColor.white
        cell.wordsCountLabel.textColor = UIColor.white
        cell.wordsCountLabel.text = countsLabelText[indexPath.row]
        cell.coverView.backgroundColor = colors[indexPath.row].withAlphaComponent(0.7)
    
        cell.cellButton.tag = indexPath.row
        cell.cellButton.backgroundColor = cellButtonColors[indexPath.row]
        cell.cellButton.setTitle("GO TO LEVEL", for: .normal)
        cell.cellButton.setTitleColor(UIColor.white, for: .normal)
       
        cell.levelLabel.text! = levels[indexPath.row]
        cell.gradeLabel.text! = grades[indexPath.row]
        
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 2
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: -5, height: 5)
        
        
        print("frame")
        print(cell.frame)
        
        return cell
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
     
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeigth = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeigth) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: cellWidth, height: cellHeigth)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetY)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offSet = targetContentOffset.pointee
        
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offSet = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        targetContentOffset.pointee = offSet
        
        
        print("pointee")
        print(targetContentOffset.pointee)
        print("index")
        print(Int(index))
        
        
        
        
        
    }
    
    


}

