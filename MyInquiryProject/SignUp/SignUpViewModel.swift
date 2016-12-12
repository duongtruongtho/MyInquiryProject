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

class SignUpViewModel: NSObject {
    
    var username = ""
    var phoneNumber = ""
    var password = ""
    var retypePassword = ""
    
    var isShowDialog = Variable<Bool>(false)
    var isRegisterSuccessful = Variable<Bool>(false)
    var isShowIndicator = Variable<Bool>(false)
    var dialogContent = ""
    
    override init() {
        super.init()
    }
    
    // MARK: - Public func
    func register() {
        if username.isEmpty
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
        
        isShowIndicator.value = true
        let email = username + "@gmin.com"
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user: FIRUser?, error: Error?) in
            guard let selfInstance = self else { return }
            
            selfInstance.isShowIndicator.value = false
            if let error = error {
                selfInstance.dialogContent = error.localizedDescription
                selfInstance.isShowDialog.value = true
                return
            }
            
            selfInstance.isRegisterSuccessful.value = true
        })
    }
}
