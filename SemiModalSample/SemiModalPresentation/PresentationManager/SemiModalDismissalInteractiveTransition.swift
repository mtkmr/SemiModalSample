//
//  SemiModalDismissalInteractiveTransition.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

//viewController間でインタラクティブなアニメーションを管理するオブジェクト
//モーダルをドラッグしたときのdismissアニメーションを設定する
final class SemiModalDismissalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    //モーダル表示しているViewController
    var viewController: UIViewController?
    
    //遷移中かどうか判定
    private(set) var isInteractiveDismissalTransition = false
    //完了閾値 (0 ~ 1)
    private let percentCompleteThreshold: CGFloat = 0.3
    
    //ジェスチャーの方向
    private var gestureDirection = GestureDirection.down
    
    ///overrideメソッド
    override func cancel() {
        //アニメーション遷移速度
        completionSpeed = percentCompleteThreshold
        super.cancel()
    }
    
    override func finish() {
        //アニメーション遷移速度
        completionSpeed = 1.0 - percentCompleteThreshold
        super.finish()
    }
}

//MARK: - pan gesture
extension SemiModalDismissalInteractiveTransition  {
    //pan gestureの向きが負のとき.up、正のとき.downとしてgesutureの方向を返す
    enum GestureDirection {
        case up
        case down
        
        init(recognizer: UIPanGestureRecognizer, view: UIView) {
            //パンジェスチャーの速度
            let velocity = recognizer.velocity(in: view)
            self = velocity.y <= 0 ? .up : .down
        }
    }
    
    //pan gestureを追加する
    func addPanGesture (to views: [UIView]) {
        views.forEach {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissalPanGesture(_:)))
            panGesture.delegate = self
            $0.addGestureRecognizer(panGesture)
        }
    }
    
    ///pan gestureメソッド
    @objc
    func dismissalPanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let viewController = viewController else { return }
        
        //遷移しているかどうかの判定は遷移が開始した、または遷移中のどちらかのとき
        isInteractiveDismissalTransition = recognizer.state == .began || recognizer.state == .changed
        
        switch recognizer.state {
        case .began:
            gestureDirection = GestureDirection(recognizer: recognizer, view: viewController.view)
            //下向きのpanならば、dismiss
            if gestureDirection == .down {
                viewController.dismiss(animated: true, completion: nil)
            }
        case .changed:
            //インタラクティブな制御なので、Viewの高さに応じた画面更新を行う
            let transition = recognizer.translation(in: viewController.view)
            //画面の高さに対するpan移動量の割合
            let progress = transition.y / viewController.view.bounds.size.height
            
//            switch gestureDirection {
//            case .up:
//                progress = -max(-1.0, max(-1.0, progress))
//            case .down:
//                progress = min(1.0, max(0, progress))
//            }
            //トランジションの完了率を更新してシステムに報告。ある閾値を超えたらイベント追跡を停止してfinish()かcancel()を呼んでくれる
            update(progress)
        case .cancelled, .ended:
            //panを終えたとき、完了閾値を超えるかどうかによる処理
            //percentCompleteはupdate()メソッドによって最後にシステムに渡された値を反映している
            if percentComplete > percentCompleteThreshold {
                //閾値を超えた場合は遷移終了メソッド
                finish()
            } else {
                //閾値を超えなかった場合はキャンセルメソッド
                cancel()
            }
        default:
            break
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SemiModalDismissalInteractiveTransition: UIGestureRecognizerDelegate {
    //scrollViewのときにpanGestureとコンフリクトしないようにする
    ///２つのジェスチャ認識エンジンが同時に認識できるようにするかどうかをデリゲートに尋ねるメソッド
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer.view is UIScrollView {
            return true
        } else {
            return false
        }
    }
}

