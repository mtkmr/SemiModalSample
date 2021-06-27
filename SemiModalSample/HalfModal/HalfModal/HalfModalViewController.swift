//
//  HalfModalViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/27.
//

import UIKit

final class HalfModalViewController: UIViewController {
    static func makeFromStoryboard() -> Self {
        return UIStoryboard(name: "HalfModal", bundle: nil).instantiateInitialViewController() as! Self
    }
//    MARK: - プロパティ
    //制約
    //ハーフモーダルの高さ
    @IBOutlet private weak var halfModalViewHeightConstraint: NSLayoutConstraint!
    //slideViewのcenterY
    @IBOutlet private weak var slideViewCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var slideView: UIView! {
        didSet {
            //タップされたらアクション発生する
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideViewTapped(_:)))
            slideView.addGestureRecognizer(tapGesture)
        }
    }
    
//    MARK: - IB部品
    @IBOutlet private weak var topBarView: UIView! {
        didSet {
            //一応見栄え良くするために角を丸くしておく
            topBarView.layer.cornerRadius = topBarView.frame.size.height / 2
            //tapGesture
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topBarViewTapped(_:)))
            topBarView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet private weak var halfModalView: UIView!
    
    @IBOutlet private weak var upButton: UIButton! {
        didSet {
            //button tap
            upButton.addTarget(self, action: #selector(upButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var downButton: UIButton! {
        didSet {
            //button tap
            downButton.addTarget(self, action: #selector(downButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
//    MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultPosition()
    }
}

//MARK: - アクション メソッド
extension HalfModalViewController {
    
    @objc func slideViewTapped(_ recognizer: UITapGestureRecognizer) {
        //ハーフモーダルを閉じる
        dismissModal()
    }
    
    @objc func topBarViewTapped(_ recognizer: UITapGestureRecognizer) {
        //ハーフモーダルを閉じる
        dismissModal()
    }
    
    @objc func upButtonTapped(_ sender: UIButton) {
        extendModal()
    }
    
    @objc func downButtonTapped(_ sender: UIButton) {
        shrinkModal()
    }
}

//MARK: - メソッド
extension HalfModalViewController {
    
    func showHalfModal() {
        //centerY制約のconstantを0にして、画面中央に表示
        slideViewCenterYConstraint.constant = 0
        //アニメーションさせながら制約を更新
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissModal() {
        //centerYの制約のconstantをviewの高さ分にして下に下げる
        slideViewCenterYConstraint.constant = view.frame.size.height / 2
        //halfModalViewの高さが大元のviewの半分超えてたらhalfModalViewは下がりきらない
        
        //アニメーションさせながら制約を更新
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            //完了したらこのviewController自体をdismiss
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func setDefaultPosition() {
        //HalfModalViewControllerを表示したら最初は下に下がっててほしいから
        slideViewCenterYConstraint.constant = view.frame.size.height / 2
        view.layoutIfNeeded()
        
    }
    
    private func extendModal() {
        //ハーフモーダルを上に伸ばす
        halfModalViewHeightConstraint.constant = view.frame.size.height * 0.8
        //アニメーションさせながら制約を更新
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func shrinkModal() {
        //ハーフモーダルを下げる
        halfModalViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
}
