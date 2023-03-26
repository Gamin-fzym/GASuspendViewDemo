//
//  ViewController.swift
//  GASuspendViewDemo
//
//  Created by Gamin on 2023/3/26.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GASuspendManager.shared.setSuspendData()
    }

    @IBAction func tapNextAction(_ sender: Any) {
        let vc = NextVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

