//
//  NextVC.swift
//  GASuspendViewDemo
//
//  Created by Gamin on 2023/3/26.
//

import Foundation
import UIKit

class NextVC: BaseViewController {
    
    lazy var returnBut: UIButton = {
        let but = UIButton()
        but.setTitle("返回", for: .normal)
        but.setTitleColor(.blue, for: .normal)
        but.frame = CGRectMake(15, 44, 80, 40)
        but.addTarget(self, action: #selector(tapReturnAction(sender:)), for: .touchUpInside)
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(returnBut)
    }

    @objc private func tapReturnAction(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
