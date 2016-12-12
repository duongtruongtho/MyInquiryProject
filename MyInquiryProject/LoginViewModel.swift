//
//  LoginViewModel.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/11/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class LoginViewModel: NSObject {
    
    var username = ""
    var password = ""
    var isShowDialog = Variable<Bool>(false)
    var contentDialog = ""
    var presentViewController = Variable<UIViewController?>(nil)
    var isShowIndicator = Variable<Bool>(false)
    
    override init() {
        super.init()
        
        bindingData()
    }
    
    // MARK: - Private func
    private func bindingData() {
        
    }
    
    // MARK: - Public func
    func login() {
        if username.isEmpty || password.isEmpty {
            return
        }
        
        isShowIndicator.value = true
        let email = username + "@gmin.com"
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { [weak self] (user: FIRUser?, error: Error?) in
            guard let selfInstance = self else { return }
            
            selfInstance.isShowIndicator.value = false
            if let error = error {
                selfInstance.contentDialog = error.localizedDescription
                selfInstance.isShowDialog.value = true
                return
            }
            
            selfInstance.contentDialog = "Login Sucess !"
            selfInstance.isShowDialog.value = true
        }
    }
    
    func signUp() {
        let signUpViewController = SignUpViewController.create()
        presentViewController.value = signUpViewController
    }
    
    func forgotPassword() {
    
    }
    
}
