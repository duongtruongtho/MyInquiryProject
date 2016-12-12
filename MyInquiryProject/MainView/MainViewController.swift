//
//  MainViewController.swift
//  MyInquiryProject
//
//  Created by ユンタンハイチュン　トォー on 12/12/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit


class MainViewController: UITabBarController {
    
    static let storyboardIdentifier = "MainViewController"
    
    class func create() -> MainViewController? {
        guard let viewController = UIStoryboard(name: MainViewController.storyboardIdentifier, bundle: nil).instantiateInitialViewController() as? MainViewController else { return nil }
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
