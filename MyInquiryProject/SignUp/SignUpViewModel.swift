//
//  SignUpViewModel.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/11/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import Firebase

class SignUpViewModel: NSObject {
    
    var fullName = ""
    var username = ""
    var phoneNumber = ""
    var password = ""
    var retypePassword = ""
    
    var isShowDialog = Variable<Bool>(false)
    var isRegisterSuccessful = Variable<Bool>(false)
    var isShowIndicator = Variable<Bool>(false)
    var dialogContent = ""
    var defaultKeyword: [String : AnyObject]?
    var defaultUserMode: [String : AnyObject]?
    
    var ref: FIRDatabaseReference!
    
    override init() {
        super.init()
        ref = FIRDatabase.database().reference()
    }
    
    // MARK: - Public func
    func register() {
        if fullName.isEmpty
        || username.isEmpty
        || phoneNumber.isEmpty
        || password.isEmpty
        || retypePassword.isEmpty {
            dialogContent = "Please input all of informations before submit !"
            isShowDialog.value = true
            return
        }
        
        if password != retypePassword {
            dialogContent = "Password and retype Password are not same. Check it !"
            isShowDialog.value = true
            return
        }
        
        if !GMINUtil.isInternetAvailable() {
            dialogContent = "Please check network connection !"
            isShowDialog.value = true
            return
        }
        
        isShowIndicator.value = true
        
        FirebaseDatabaseUtil.getListUserMode { [weak self] (listUserMode: Array<[String : AnyObject]>?) in
            guard let listUserMode = listUserMode else {
                self?.dialogContent = "Realtime Database got a problem !"
                self?.isShowDialog.value = true
                self?.isShowIndicator.value = false
                return
            }
            
            if let defaultUserMode = listUserMode.first {
                self?.defaultUserMode = defaultUserMode
            }
            
            FirebaseDatabaseUtil.getListKeyword(withCompleteHandler: { [weak self] (listKeyword: Array<[String : AnyObject]>?) in
                guard let listKeyword = listKeyword else {
                    self?.dialogContent = "Realtime Database got a problem !"
                    self?.isShowDialog.value = true
                    self?.isShowIndicator.value = false
                    return
                }
                
                if let defaultKeyword = listKeyword.first {
                    self?.defaultKeyword = defaultKeyword
                }
                
                self?.createUserAccountAtDatabase()
            })
        }
    }
    
    // MARK: - Private func
    private func createUserAccountAtDatabase() {
        
        if self.defaultKeyword == nil
            && self.defaultUserMode == nil
            && !GMINUtil.isInternetAvailable() {
            self.isShowIndicator.value = false
            return
        }
        
        // register user in realtime database
        self.ref.child("users").child(username).observeSingleEvent(of: FIRDataEventType.value, with: { [weak self] (snapshot: FIRDataSnapshot) in
            guard let selfInstance = self else { return }
            if snapshot.exists() {
                selfInstance.dialogContent = "Username had register already !"
                selfInstance.isShowDialog.value = true
                selfInstance.isShowIndicator.value = false
                return
            }
            
            selfInstance.ref.child("users/\(selfInstance.username)").setValue(self?.userData())
            
            let email = selfInstance.username + "@gmin.com"
            FIRAuth.auth()?.createUser(withEmail: email, password: selfInstance.password, completion: { [weak self] (user: FIRUser?, error: Error?) in
                guard let safeSelf = self else { return }
                
                safeSelf.isShowIndicator.value = false
                if let error = error {
                    selfInstance.ref.child("users").child(safeSelf.username).removeValue()
                    safeSelf.dialogContent = error.localizedDescription
                    safeSelf.isShowDialog.value = true
                    return
                }
                
                selfInstance.isRegisterSuccessful.value = true
            })
        })
    }
    
    private func userData() -> NSDictionary {
        return ["Name": fullName,
                "Password": password,
                "Telephone": phoneNumber,
                "Username": username,
                "defaultKeywords": (defaultKeyword != nil) ? [defaultKeyword] : [],
                "userMode": defaultUserMode ?? [:]]
    }
}
