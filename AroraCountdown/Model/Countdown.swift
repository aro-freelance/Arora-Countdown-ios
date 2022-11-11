//
//  Countdown.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import Foundation
import RealmSwift

//this file defines what each countdown object will have

class Countdown : Object {
    
    
    @objc dynamic var id : Int = 0
    
    @objc dynamic var title : String = ""
    
    @objc dynamic var countdownDate : Date = Date()
    
    @objc dynamic var dateCreated : Date = Date()
    
    @objc dynamic var isDone : Bool = false
    
    @objc dynamic var notificationOn : Bool = false
    
    
    
}
