//
//  SemiModalPresentationManager.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

public protocol SemiModalPresentationManagerDelegate: AnyObject {
    /// ViewController側にモーダルの高さを委任する
    var semiModalContentHeight: CGFloat { get }
}

//ViewControllerのpresentationを管理するオブジェクト
final class SemiModalPresentationManager: NSObject {
    //モーダル表示するするViewControllerの設定
    weak var viewController: UIViewController? {
        didSet {
            if let viewController = viewController {
                viewController.modalPresentationStyle = .custom
                viewController.transitioningDelegate = self
                dismissInteractiveTransition.viewController = viewController
                dismissInteractiveTransition.addPanGesture(to: [viewController.view, overlayView, topBarView])
            }
        }
    }
    
    //オーバーレイビュー
    private lazy var overlayView: SemiModalOverlayView = {
        let overlayView = SemiModalOverlayView()
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayTapped(_:))))
        return overlayView
    }()
    
    //モーダルの上部に表示するbarView
    private lazy var topBarView: SemiModalTopBarView = {
        let topBarView = SemiModalTopBarView()
        topBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topBarViewTapped(_:))))
        return topBarView
    }()
    
    //インタラクティブなdismiss transitionを管理するオブジェクトをインスタンス化
    private let dismissInteractiveTransition = SemiModalDismissalInteractiveTransition()
    
}

//MARK: - gesture method
extension SemiModalPresentationManager {
    ///オーバーレイがタップされたとき
    @objc func overlayTapped(_ sender: UITapGestureRecognizer) {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    ///topBarViewがタップされたとき
    @objc func topBarViewTapped(_ sender: UITapGestureRecognizer) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension SemiModalPresentationManager: UIViewControllerTransitioningDelegate {
    
    ///viewControllerのpresentationStyleがcustomのとき呼ばれ、UIPresentationControllerを返すメソッド
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SemiModalPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            overlayView: overlayView,
            topBarView: topBarView)
    }
    
    ///dismissのときに呼ばれる。dismissのアニメーションを指定する
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SemiModalDismissalAnimatedTransition()
    }
    
    ///インタラクティブなdismissを制御する
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard dismissInteractiveTransition.isInteractiveDismissalTransition else {
            return nil
        }
        return dismissInteractiveTransition
    }
    
}

