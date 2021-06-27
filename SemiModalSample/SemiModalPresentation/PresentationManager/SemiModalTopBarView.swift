//
//  SemiModalTopBarView.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

final class SemiModalTopBarView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

extension SemiModalTopBarView {
    private func setup() {
//        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        backgroundColor = UIColor.lightGray
    }
}
