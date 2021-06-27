//
//  HomeViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/27.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
    func didTapOverlay()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.frame = view.frame
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.5
        overlayView.isHidden = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOverlay(_:))))
        return overlayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton(_:)))
    }
    
    private func setupView() {
        //self.view
        view.backgroundColor = .systemBackground
        title = "Home"
        //overlay
        navigationController?.view.addSubview(overlayView)
    }
    
    @objc func didTapMenuButton(_ sender: UIBarButtonItem) {
        delegate?.didTapMenuButton()
    }
    
    @objc func didTappedOverlay(_ sender: UIButton) {
        delegate?.didTapOverlay()
    }
    

    

}
