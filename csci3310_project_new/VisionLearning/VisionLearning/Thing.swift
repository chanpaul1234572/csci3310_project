//
//  Thing.swift
//  VisionLearning
//
//  Created by Chan Paul on 19/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Thing : NSObject, NSCoding{
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
    struct PropertyKey{
        static let englishName = "englishName"
        static let imageOfTheThing = "imageOfTheThing"
        static let translatedName = "translatedName"
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(englishName, forKey: PropertyKey.englishName)
        aCoder.encode(photo, forKey: PropertyKey.imageOfTheThing)
        aCoder.encode(translatedName, forKey: PropertyKey.translatedName)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let englishName = aDecoder.decodeObject(forKey: PropertyKey.englishName) as? String else{
            os_log("Unable to decode")
            return nil
        }
        let imageOfTheThing = aDecoder.decodeObject(forKey: PropertyKey.imageOfTheThing) as? UIImage
        
        let translatedName = aDecoder.decodeObject(forKey: PropertyKey.translatedName) as! String
        
        self.init(englishName: englishName, photo: imageOfTheThing, translatedName: translatedName)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("things")
    
}
