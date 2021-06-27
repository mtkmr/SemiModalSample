//
//  AnimationViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/27.
//

import UIKit

final class AnimationViewController: UIViewController {

    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var showButton: UIButton! {
        didSet {
            showButton.addTarget(self, action: #selector(showButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var fillView: UIView! {
        didSet {
            fillView.layer.cornerRadius = fillView.frame.size.height / 2
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet private weak var twitterShareButton: UIButton!
    @IBOutlet private weak var facebookShareButton: UIButton!
    @IBOutlet private weak var githubShareButton: UIButton!
    @IBOutlet private weak var instagramShareButton: UIButton!
    @IBOutlet private weak var lineShareButton: UIButton!
    @IBOutlet private weak var tiktokShareButton: UIButton!
    @IBOutlet private weak var youtubeShareButton: UIButton!
    @IBOutlet private weak var pintarestShareButton: UIButton!
    
//    MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "animation"
        
        twitterShareButton.alpha = 0
        facebookShareButton.alpha = 0
        githubShareButton.alpha = 0
        instagramShareButton.alpha = 0
        lineShareButton.alpha = 0
        tiktokShareButton.alpha = 0
        youtubeShareButton.alpha = 0
        pintarestShareButton.alpha = 0
    }
}

private extension AnimationViewController {
    
    @objc
    func showButtonTapped(_ sender: UIButton) {
        //1回転
        if showButton.transform == .identity {
            UIView.animate(withDuration: 0.2) {
                
            } completion: { (_) in
                
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                
            } completion: { (_) in
                
            }
        }
        
        //fillViewが広がる
        if fillView.transform == .identity {
            UIView.animate(withDuration: 0.5) {
                self.fillView.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.showButton.transform = CGAffineTransform(rotationAngle: self.radian(180))
            } completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.toggleSharedButton()
                })
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.fillView.transform = .identity
                self.menuView.transform = .identity
                self.showButton.transform = .identity
                self.toggleSharedButton()
            }
        }
    }
    
    private func toggleSharedButton() {
        let alpha = twitterShareButton.alpha == 0 ? 1.0 : 0
        twitterShareButton.alpha = CGFloat(alpha)
        facebookShareButton.alpha = CGFloat(alpha)
        githubShareButton.alpha = CGFloat(alpha)
        instagramShareButton.alpha = CGFloat(alpha)
        lineShareButton.alpha = CGFloat(alpha)
        tiktokShareButton.alpha = CGFloat(alpha)
        youtubeShareButton.alpha = CGFloat(alpha)
        pintarestShareButton.alpha = CGFloat(alpha)
    }
    
    private func radian (_ degrees: Double) -> CGFloat {
        return CGFloat(degrees / 180 * Double.pi)
    }
}
