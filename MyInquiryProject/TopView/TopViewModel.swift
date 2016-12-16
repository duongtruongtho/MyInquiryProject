//
//  TopViewModel.swift
//  MyInquiryProject
//
//  Created by Dương Thảnh Hải Trường Thọ on 12/17/16.
//  Copyright © 2016 ThoPhat. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TopViewModel: NSObject {
    var inquiryList = Variable<[String: AnyObject]>([:])
    
    override init() {
        super.init()
    }
}
