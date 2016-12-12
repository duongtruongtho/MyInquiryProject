//
//  LoginViewController.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/11/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    let dispose = DisposeBag()
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.isHidden = true
        
        bindingUI()
    }

    private func bindingUI() {
        txtUsername.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.username = text
                } else {
                    self?.viewModel.username = ""
                }
            }.addDisposableTo(self.dispose)
        
        txtPassword.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.password = text
                } else {
                    self?.viewModel.password = ""
                }
            }.addDisposableTo(self.dispose)
        
        loginButton.rx.tap
            .asObservable()
            .bindNext { [weak self] in
                self?.viewModel.login()
            }.addDisposableTo(self.dispose)
        
        signUpButton.rx.tap
            .asObservable()
            .bindNext { [weak self] in
                self?.viewModel.signUp()
            }.addDisposableTo(self.dispose)
        
        forgotPasswordButton.rx.tap
            .asObservable()
            .bindNext { [weak self] in
                self?.viewModel.forgotPassword()
            }.addDisposableTo(self.dispose)
        
        //ViewModel
        viewModel.isShowDialog
            .asObservable()
            .filter{ $0 && !self.viewModel.contentDialog.isEmpty }
            .bindNext{ [weak self] _ in
                guard let selfInstance = self else { return }
                selfInstance.presentDialog(withContent: selfInstance.viewModel.contentDialog)
            }.addDisposableTo(self.dispose)
        viewModel.presentViewController
            .asObservable()
            .filter{ $0 != nil }
            .bindNext{ [weak self] (viewController: UIViewController?) in
                guard let viewController = viewController else { return }
                self?.present(viewController, animated: true, completion: nil)
            }.addDisposableTo(self.dispose)
        viewModel.isShowIndicator
            .asObservable()
            .bindNext{ [weak self] (isShow: Bool) in
                guard let selfInstance = self else { return }
                if isShow {
                    selfInstance.view.isUserInteractionEnabled = false
                    selfInstance.indicator.isHidden = false
                    selfInstance.indicator.startAnimating()
                } else {
                    selfInstance.view.isUserInteractionEnabled = true
                    selfInstance.indicator.isHidden = true
                    selfInstance.indicator.stopAnimating()
                }
            }.addDisposableTo(self.dispose)
    }
    
    // MARK: - Private func
    private func presentDialog(withContent content: String) {
        let alert = UIAlertController(title: content, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

