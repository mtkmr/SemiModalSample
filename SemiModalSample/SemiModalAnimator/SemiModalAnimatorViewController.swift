//
//  MapViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/24.
//

import UIKit
import MapKit

//MARK: - State
private enum ModalState {
    case open
    case closed
}

extension ModalState {
    var opposite: ModalState {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}

//MARK: - View Controller
final class SemiModalAnimatorViewController: UIViewController {
    
//    MARK: - Properties
    //アニメーションの現在の状態。アニメーションが完了したときにのみ変更される
    private var currentState: ModalState = .closed
    
    //現在走っているアニメーター
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    //各アニメータの進捗状況。各アニメーターと並列に格納されている。
    private var animationProgress = [CGFloat]()
    
    //Pan Gesture
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let panRecognizer = InstantPanGestureRecognizer(target: self, action: #selector(modalViewPanned(_:)))
        return panRecognizer
    }()
    
    //bottom constraint
    private var bottomConstraint = NSLayoutConstraint()
    
    //semi modalの高さ
    private let modalHeight: CGFloat = 500
    private let modalOffset: CGFloat = 440
    
//    MARK: - Views
    //セミモーダル
    private lazy var semiModalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //影をつける
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        //角を丸くする
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //pan gesture
        view.addGestureRecognizer(panRecognizer)
        return view
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var closedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Half Modal"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .orange
        label.textAlignment = .center
        return label
    }()
    
    private lazy var openTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Half Modal"
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        return label
    }()
    
    
//    MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIViewPropertyAnimator"
        layout()
    }
}

//MARK: - action method
private extension SemiModalAnimatorViewController {
    @objc
    private func modalViewPanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //アニメーションを開始する
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1.0)
            //panが変更される可能性があり、その動きに合わせるためanimatorを一時停止する
            runningAnimators.forEach {
                $0.pauseAnimation()
            }
            //各animatorの進捗状況を把握する
            animationProgress = runningAnimators.map { $0.fractionComplete }
        case .changed:
            //panのtransitionを取得
            let transition = recognizer.translation(in: semiModalView)
            //現在の状態と反転した状態の完了率を調整する(向き調整)
            var fractionComplete = -transition.y / modalOffset
            if currentState == .open {
                fractionComplete *= -1
            }
            if runningAnimators[0].isReversed {
                fractionComplete *= -1
            }
            
            //現在の進捗率に動かした分の完了率を追加する
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fractionComplete + animationProgress[index]
            }
            
        case .ended:
            //y方向の速度
            let yVelocity = recognizer.velocity(in: semiModalView).y
            //panの方向が正(閉じる方向)のとき閉じる判定をtrueにする
            let shouldClose = yVelocity > 0
            //速度が0のとき、全てのアニメーションを続行してすぐに終了する
            if yVelocity == 0 {
                runningAnimators.forEach {
                    $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
                break
            }
            
            //現在の状態とpanの向き(考えられるパターン全て)を考慮してアニメーションを反転している
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed {
                    runningAnimators.forEach {
                        $0.isReversed = !$0.isReversed
                    }
                }
                if shouldClose && runningAnimators[0].isReversed {
                    runningAnimators.forEach {
                        $0.isReversed = !$0.isReversed
                    }
                }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed {
                    runningAnimators.forEach {
                        $0.isReversed = !$0.isReversed
                    }
                }
                if !shouldClose && runningAnimators[0].isReversed {
                    runningAnimators.forEach {
                        $0.isReversed = !$0.isReversed
                    }
                }
            }
            //アニメーションを続行して、すぐに終了している
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
}

//MARK: - private method
private extension SemiModalAnimatorViewController {
    
    private func layout() {
        //semiModalView
        semiModalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(semiModalView)
        bottomConstraint = semiModalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: modalOffset)
        NSLayoutConstraint.activate([semiModalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     semiModalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     bottomConstraint,
                                     semiModalView.heightAnchor.constraint(equalToConstant: modalHeight)])
        //settingButton
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingButton)
        NSLayoutConstraint.activate([settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48), settingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100), settingButton.heightAnchor.constraint(equalToConstant: 40), settingButton.widthAnchor.constraint(equalToConstant: 40)])
        
        
        //closedTitleLabel
        closedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        semiModalView.addSubview(closedTitleLabel)
        NSLayoutConstraint.activate([closedTitleLabel.leadingAnchor.constraint(equalTo: semiModalView.leadingAnchor),
                                     closedTitleLabel.trailingAnchor.constraint(equalTo: semiModalView.trailingAnchor),
                                     closedTitleLabel.topAnchor.constraint(equalTo: semiModalView.topAnchor, constant: 20)])
        //openTitleLabel
        openTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        semiModalView.addSubview(openTitleLabel)
        NSLayoutConstraint.activate([openTitleLabel.leadingAnchor.constraint(equalTo: semiModalView.leadingAnchor),
                                     openTitleLabel.trailingAnchor.constraint(equalTo: semiModalView.trailingAnchor),
                                     openTitleLabel.topAnchor.constraint(equalTo: semiModalView.topAnchor, constant: 30)])
        
    }
    
    ///アニメーションがまだ実行されていなければ、トランジションをアニメーション化する
    //state: 次の状態
    private func animateTransitionIfNeeded(to state: ModalState, duration: TimeInterval) {
        //animatorの配列が空であれば、新しいanimatorを作成する
        guard runningAnimators.isEmpty else { return }
        //transitionのためのanimatorを作成
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0, animations: {
            switch state {
            case .open:
                //モーダルの位置
                self.bottomConstraint.constant = 0
                //角を丸くする
                self.semiModalView.layer.cornerRadius = 20
                //titleLabel
                self.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.openTitleLabel.transform = .identity
            case .closed:
                self.bottomConstraint.constant = self.modalOffset
                self.semiModalView.layer.cornerRadius = 0
                self.closedTitleLabel.transform = .identity
                self.openTitleLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.view.layoutIfNeeded()
        })
        
        //遷移完了時の処理ブロック
        transitionAnimator.addCompletion { (position) in
            //現在のstateを更新
            switch position {
            case .start:
                self.currentState = state.opposite //現在のstate
            case .current:
                ()
            case .end:
                self.currentState = state //次のstate
            @unknown default:
                fatalError()
            }
            
            //起動しているanimatorを破棄
            self.runningAnimators.removeAll()
        }
        
        //settingButtonのanimatorを作成(transitionAnimatorと別のtransitionCurveを使用したいときは、別のanimatorを生成する必要がある)
        let settingButtonAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.settingButton.alpha = 0
            case .closed:
                self.settingButton.alpha = 1.0
            }
        })
        //animatorがlinearではなく他の指定したタイミングカーブに従う
        settingButtonAnimator.scrubsLinearly = false
        
        //viewに現れるtitleのanimator
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.openTitleLabel.alpha = 1
            case .closed:
                self.closedTitleLabel.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        //viewから消えていくtitleのanimator
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.closedTitleLabel.alpha = 0
            case .closed:
                self.openTitleLabel.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        //animatorを全て起動する
        transitionAnimator.startAnimation()
        settingButtonAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        //animatorを全て管理する
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(settingButtonAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
    }
    
}
