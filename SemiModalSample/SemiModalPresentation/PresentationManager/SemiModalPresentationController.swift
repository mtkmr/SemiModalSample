//
//  SemiModalPresentationController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

//遷移アニメーションと画面上のビューコントローラの表示を管理するオブジェクト
class SemiModalPresentationController: UIPresentationController {
    //オーバーレイview
    private let overlay: SemiModalOverlayView
    
    //topBarView
    private let topBarView: SemiModalTopBarView
    
    //セミモーダルの高さのデフォルト比率
    private let presentedVCHeightRatio: CGFloat = 0.5
    
    ///transition終了時に表示されたViewのframeを返すoverrideメソッド
    //ここではcontainerViewの子View、つまり表示されるViewのframeを返す
    override var frameOfPresentedViewInContainerView: CGRect {
        //presentationが起こるView。一番親Viewという認識。
        guard let containerView = containerView else { return CGRect.zero }
        //containerViewの全体
        let containerBounds = containerView.bounds
        //表示されるviewのframeを設定
        var presentedViewFrame = CGRect.zero
        //ここでsize(forChildContentContainer:,withParentContainerSize:)メソッドで表示されるViewの高さが渡されている
        //すなわち、モーダルが画面のどれくらいを埋め尽くすかを設定している
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        return presentedViewFrame
    }
    
    //イニシャライザ
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, overlayView: SemiModalOverlayView, topBarView: SemiModalTopBarView) {
        self.overlay = overlayView
        self.topBarView = topBarView
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    ///表示されるview (セミモーダル)のサイズを返すメソッド
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        //デリゲート先でが存在して高さが指定されていればそれを優先して返す
        if let delegate = presentedViewController as? SemiModalPresentationManagerDelegate {
            return CGSize(width: parentSize.width, height: delegate.semiModalContentHeight)
        }
        //それ以外のとき、高さは比率で返す
        return CGSize(width: parentSize.width, height: parentSize.height * presentedVCHeightRatio)
    }
    
    ///SubViewsのレイアウト(addViews)
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        
        //overlayのレイアウト
        //containerViewと同じ大きさ(画面全体)で、一番上のレイヤーに挿入する←一番上のレイヤーでないと、overlayが最前面にきてしまう
        overlay.frame = containerView.bounds
        containerView.insertSubview(overlay, at: 0)
       
        //presentedViewのレイアウト
        //frame設定は上で設定したframeOfPresentedViewInContainerView。上角２つを角丸にしておく。
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10.0
//        presentedView?.layer.masksToBounds = true
        //角丸にしたいviewの角を指定してあげるだけで角丸になる
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //topBarViewのレイアウト
        //モーダル中央上部に配置する
        topBarView.frame = CGRect(x: 0, y: 0, width: 60, height: 8)
        presentedViewController.view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.centerXAnchor.constraint(equalTo: presentedViewController.view.centerXAnchor),
            topBarView.topAnchor.constraint(equalTo: presentedViewController.view.topAnchor, constant: -16),
            topBarView.widthAnchor.constraint(equalToConstant: topBarView.frame.width),
            topBarView.heightAnchor.constraint(equalToConstant: topBarView.frame.height)
        ])
    }
    
    
    ///Viewの表示/非表示/削除を制御するoverrideメソッド
    ///presentation transition開始するとき
    override func presentationTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.overlay.isActive = true
        }, completion: nil)
    }
    
    ///presentation transition終了するとき
//    override func presentationTransitionDidEnd(_ completed: Bool) {
//
//    }
    
    //dismiss transition開始するとき
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.overlay.isActive = false
        }, completion: nil)
    }
    
    ///dismiss transition終了するとき
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            //不要かも
            //dismissしたときにちゃんと消されていることは確認済み
            overlay.removeFromSuperview()
        }
    }
}
