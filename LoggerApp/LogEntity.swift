//
//  Log.swift
//  LoggerApp
//
//  Created by Ahmed Nasser on 12/19/20.
//  Copyright © 2020 Instabug. All rights reserved.
//

import Foundation
import CoreData

class LogEntity :NSManagedObject{
    @NSManaged var level :String
    @NSManaged var message :String
    @NSManaged var date:Date
    
    func update(message:String,errorLevel:String) {
        self.date = Date()
        self.message = message
        self.level = errorLevel
    }
}
