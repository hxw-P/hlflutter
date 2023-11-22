//
//  NativeTestDetailCrl.swift
//  Runner
//
//  Created by 华晓伟 on 2023/11/22.
//

import UIKit

class NativeTestDetailCrl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = UIButton(type:UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        button.setTitle("back to home!", for: UIControl.State.normal)
        button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
    }
    
    @objc func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
