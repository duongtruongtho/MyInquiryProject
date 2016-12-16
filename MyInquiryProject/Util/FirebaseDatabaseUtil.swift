//
//  FirebaseDatabaseUtil.swift
//  MyInquiryProject
//
//  Created by ユンタンハイチュン　トォー on 12/16/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class FirebaseDatabaseUtil: NSObject {
    
    class func getListUserMode(withCompleteHandler completeHandler: @escaping ((Array<[String : AnyObject]>?) -> Void)) {
        let ref = FIRDatabase.database().reference()
        ref.child("user_mode").observe(FIRDataEventType.value, with: {(snapshot: FIRDataSnapshot) in
            guard let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                completeHandler(nil)
                return
            }
            
            let listUserMode = snapshots.map { (snap: FIRDataSnapshot) in (snap.value as? [String : AnyObject]) ?? [:] }
            completeHandler(listUserMode)
        })
    }
    
    class func getListKeyword(withCompleteHandler completeHandler: @escaping ((Array<[String : AnyObject]>?) -> Void)) {
        let ref = FIRDatabase.database().reference()
        ref.child("keyword").observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            guard let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                completeHandler(nil)
                return
            }
            
            let listUserMode = snapshots.map { (snap: FIRDataSnapshot) in (snap.value as? [String : AnyObject]) ?? [:] }
            completeHandler(listUserMode)
        })
    }

}
