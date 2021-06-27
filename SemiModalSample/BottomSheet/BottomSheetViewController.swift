//
//  BottomSheetViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/28.
//

import UIKit

class BottomSheetViewController: UIViewController {
    //Properties
    private var isBottomCardShown = false
    
    //IBOutlet
    @IBOutlet private weak var bottomCard: UIView!
    @IBOutlet private weak var switchButton: UIButton! {
        didSet {
            switchButton.addTarget(self, action: #selector(didTapSwitchButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "notes")
        }
    }
    
    //Constraint
    @IBOutlet private weak var bottomCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomCardBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomCardLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomCardTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var switchButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var switchButtonTrailingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomCardTrailingConstraint.constant = view.frame.size.width
        view.layoutIfNeeded()
    }
    
    private func setupView() {
        switchButton.layer.cornerRadius = switchButton.frame.size.height / 2
        bottomCard.layer.cornerRadius = 20
    }
    
    @objc func didTapSwitchButton(_ sender: UIButton) {
        
        if isBottomCardShown {
            //hide bottomCard
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomCardHeightConstraint.constant = 420
                self.view.layoutIfNeeded()
            }) { [weak self] (done) in
                if done {
                    self?.isBottomCardShown.toggle()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.bottomCardHeightConstraint.constant = 0
                        self?.bottomCardTrailingConstraint.constant = (self?.view.frame.size.width)!
                        self?.view.layoutIfNeeded()
                    })
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.switchButtonTrailingConstraint.isActive = false
                self.switchButtonLeadingConstraint.constant = 16
                self.switchButtonLeadingConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
            
        } else {
            //show bottomCard
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomCardHeightConstraint.constant = 420
                self.bottomCardTrailingConstraint.constant = 16
                self.view.layoutIfNeeded()
            }) { [weak self] (done) in
                if done {
                    self?.isBottomCardShown.toggle()
                    UIView.animate(withDuration: 0.1, animations: {
                        self?.bottomCardHeightConstraint.constant = 400
                        self?.view.layoutIfNeeded()
                    })
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.switchButtonLeadingConstraint.isActive = false
                self.switchButtonTrailingConstraint.constant = 16
                self.switchButtonTrailingConstraint.isActive = true
                self.view.layoutIfNeeded()
            })
        }
        
        
    }
    


}
