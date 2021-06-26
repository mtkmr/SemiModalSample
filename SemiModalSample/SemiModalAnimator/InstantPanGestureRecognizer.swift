//
//  InstantPanGestureRecognizer.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/25.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

//PanGesture開始時にすぐに開始状態になる
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == UIGestureRecognizer.State.began {
            return
        }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
