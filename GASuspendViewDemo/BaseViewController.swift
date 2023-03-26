//
//  BaseViewController.swift
//  GASuspendViewDemo
//
//  Created by Gamin on 2023/3/26.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GASuspendManager.updateSuspendViewShow()
    }

    
}
