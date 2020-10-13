//
//  AnswersViewController.swift
//  DaysTableView
//
//  Created by çağrı on 19.04.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController {
    
    
    var answeredQuestions = [AnsweredQuestion]()
    
    var examURL : URL?
    
    var answerLetters = ["A","B","C","D","E"]
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    

    func getAnswersFromLocalData () {
        if let data = try? Data(contentsOf: examURL!) {
            do {
                answeredQuestions = try decoder.decode([AnsweredQuestion].self, from: data)
            } catch {
                print(error)
            }
        }
        
        
    }
    

}

extension AnswersViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answeredQuestions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! AnswersTableViewCell
        
        
        if indexPath.row == 0 {
            cell.qNumLabel.text = "SORU NO"
            cell.qNumLabel.font = UIFont(name: "Futura", size: 9)
            cell.correctAnswerLabel.font = UIFont(name: "Futura", size: 9)
            cell.givenAnswerLabel.font = UIFont(name: "Futura", size: 9)
            
            cell.correctAnswerLabel.text = "DOĞRU CEVAP"
            cell.givenAnswerLabel.text = "CEVABINIZ"
            
            
        } else {
            cell.qNumLabel.text = "\(indexPath.row )"
            
            cell.correctAnswerLabel.text = answerLetters[answeredQuestions[indexPath.row - 1].correctAnswer]
            cell.givenAnswerLabel.text = answerLetters[answeredQuestions[indexPath.row - 1].givenAnswer]
            if cell.correctAnswerLabel.text == cell.givenAnswerLabel.text {
                cell.givenAnswerLabel.backgroundColor = UIColor.flatGreen()
          
            
                
                
            } else {
                 cell.givenAnswerLabel.backgroundColor = UIColor.flatRed()
            }
            
            
        }
        
   
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    
    
    
}
