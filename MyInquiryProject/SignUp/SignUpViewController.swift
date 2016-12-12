//
//  SignUpViewController.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/11/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let storyboardIdentifier = "SignUpViewController"

class SignUpViewController: UIViewController {
    
    let viewModel = SignUpViewModel()
    let dispose = DisposeBag()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func create() -> SignUpViewController? {
        guard let viewController = UIStoryboard.init(name: storyboardIdentifier, bundle: nil).instantiateInitialViewController() as? SignUpViewController else { return nil }
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindingUI()
    }

    // MARK: - Private func
    private func bindingUI() {
        usernameTextField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.username = text
                } else {
                    self?.viewModel.username = ""
                }
            }.addDisposableTo(self.dispose)
        phoneNumberTextField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.phoneNumber = text
                } else {
                    self?.viewModel.phoneNumber = ""
                }
            }.addDisposableTo(self.dispose)
        passwordTextField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.password = text
                } else {
                    self?.viewModel.password = ""
                }
            }.addDisposableTo(self.dispose)
        retypePasswordTextField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asObservable()
            .bindNext{ [weak self] (text: String?) in
                if let text = text {
                    self?.viewModel.retypePassword = text
                } else {
                    self?.viewModel.retypePassword = ""
                }
            }.addDisposableTo(self.dispose)
        
        registerButton.rx.tap
            .asObservable()
            .bindNext{ [weak self] in
                self?.viewModel.register()
            }.addDisposableTo(self.dispose)
        
        //ViewModel
        viewModel.isShowDialog
            .asObservable()
            .filter{ $0 && !self.viewModel.dialogContent.isEmpty }
            .bindNext{ [weak self] _ in
                guard let selfInstance = self else { return }
                selfInstance.presentDialog(titleContent: selfInstance.viewModel.dialogContent, submitAction: nil)
            }.addDisposableTo(self.dispose)
        viewModel.isRegisterSuccessful
            .asObservable()
            .filter{$0}
            .bindNext{ [weak self] _ in
                guard let selfInstance = self else { return }
                selfInstance.registerSuccessfulAction()
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
    
    func registerSuccessfulAction() {
        self.presentDialog(titleContent: "Register Successful !", submitAction: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
    }

    // MARK: - Private func
    private func presentDialog(titleContent content: String, submitAction action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: content, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
}
