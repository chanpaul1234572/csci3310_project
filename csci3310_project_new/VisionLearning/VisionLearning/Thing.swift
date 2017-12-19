//
//  Thing.swift
//  VisionLearning
//
//  Created by Chan Paul on 19/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import Foundation
import UIKit

class Thing{
    //MARK: Properties
    var englishName: String
    var photo: UIImage?
    var translatedName: String
    
    init?(englishName: String, photo: UIImage?, translatedName: String){
        
        guard !englishName.isEmpty else{
            return nil
        }
        
        guard !translatedName.isEmpty else{
            return nil
        }
        
        self.englishName = englishName
        self.photo = photo
        self.translatedName = translatedName
    }
}
