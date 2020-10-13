//
//  TrackAnswersForWords.swift
//  ydsEnglish
//
//  Created by çağrı on 7.05.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit

struct TrackWord : Codable {
    var word : String
    var right : Int
    var wrong : Int
}

var trackedWords = [TrackWord]()


let trackedWordsURL = directory.appendingPathComponent("trackedWords").appendingPathExtension("plist")


extension WorkoutViewController {
    
    
    func trackWords(word : String, right : Bool) {
        
        
        if let data = try? Data(contentsOf: trackedWordsURL) {
            do {
                trackedWords = try! decoder.decode([TrackWord].self, from: data)
            }
            
        }
      
        
        if let index = trackedWords.firstIndex(where: {$0.word == word }) {
            
            if right {
                trackedWords[index].right += 1
                
            } else {
                trackedWords[index].wrong += 1
            }
            
        } else {
            if right {
                trackedWords.append(TrackWord(word: word, right: 1, wrong: 0))
            } else {
                trackedWords.append(TrackWord(word: word, right: 0, wrong: 1))
            }
            
        }
        
        
        do {
            let encoded = try! encoder.encode(trackedWords)
            try! encoded.write(to: trackedWordsURL)
            
        }
        
        print(trackedWords)
        
        
        
        
    }
    
    
    
    
    
    
    
}



