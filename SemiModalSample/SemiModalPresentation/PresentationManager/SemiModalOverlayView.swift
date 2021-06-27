//
//  SemiModalOverlayView.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import Foundation

import UIKit

final class SemiModalOverlayView: UIView {
    //オーバーレイviewがアクティブなら可視化、非アクティブなら透明にする
    var isActive: Bool = false {
        didSet {
            alpha = isActive ? 0.5 : 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

extension SemiModalOverlayView {
    private func setup() {
        backgroundColor = UIColor.black
        alpha = 0.5
    }
}
