//
//  PresentingViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

final class PresentingViewController: UIViewController {
    
    private let presentationManager = SemiModalPresentationManager()
    
    @IBOutlet private weak var showModalButton: UIButton! {
        didSet {
            showModalButton.addTarget(self, action: #selector(showModal(_:)), for: .touchUpInside)
        }
    }
    
    @objc func showModal(_ sender: UIButton) {
        //ハーフモーダル
        let viewController = SemiModalViewController.makeFromStoryboard()
        presentationManager.viewController = viewController
        present(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIPresentationController"
    }

}
