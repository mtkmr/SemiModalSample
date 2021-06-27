//
//  SemiModalDismissalAnimatedTransition.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

//セミモーダルのdismissが呼ばれたときにどのようにアニメーションするか設定するオブジェクト
final class SemiModalDismissalAnimatedTransition: NSObject {
    
}
//MARK: - UIViewControllerAnimatedTransitioning
//カスタムビューコントローラートランジションのアニメーションを実装するための一連のメソッドを持つインターフェース
extension SemiModalDismissalAnimatedTransition: UIViewControllerAnimatedTransitioning {
    //遷移時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //何秒でdismissするか。ここは変更の余地あり
        return 0.4
    }
    
    //アニメーションの設定
    //transitionContext: 遷移に関するviewとviewControllerの情報をカプセル化したオブジェクト
    //インタラクティブオブジェクトと協調し、進行状況をインタラクティブメソッドから報告されてアニメーションを制御できる
    //completeTransitionメソッドにより、遷移アニメーションが完了したことを伝える
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        //viewを下にスライドさせる
                        //遷移に関係する指定されたviewを返すメソッド
                        guard let fromView = transitionContext.view(forKey: .from) else { return }
                        fromView.center.y = UIScreen.main.bounds.size.height + fromView.bounds.height / 2
                       },
                       completion: { _ in
                        //遷移アニメーションが完了したことをシステムに通知するメソッド
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        
                       })
    }
}
