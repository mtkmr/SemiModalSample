//
//  PresentViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/27.
//

import UIKit

class PresentViewController: UIViewController {

    @IBOutlet private weak var showHalfModalButton: UIButton! {
        didSet {
            showHalfModalButton.addTarget(self, action: #selector(showHalfModal(_:)), for: .touchUpInside)
        }
    }
    
    @objc func showHalfModal(_ sender: UIButton) {
        let halfModalVC = HalfModalViewController.makeFromStoryboard()
        //これがないとモーダルしたときにBaseVCが後ろに下がる動きになる
        halfModalVC.modalPresentationStyle = .overCurrentContext
        halfModalVC.modalTransitionStyle = .crossDissolve
        //HalfModalViewController自体はアニメーションなしで表示させる
        //表示完了後にshowModalしてハーフモーダルをアニメーション付きで表示する
        present(halfModalVC, animated: false, completion: {
            halfModalVC.showHalfModal()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Half Modal"
    }
    

}
