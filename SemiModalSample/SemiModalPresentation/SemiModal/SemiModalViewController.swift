//
//  SemiModalViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

final class SemiModalViewController: UIViewController {
    static func makeFromStoryboard() -> SemiModalViewController {
        guard let vc = UIStoryboard.init(name: "SemiModal", bundle: nil).instantiateInitialViewController() as? SemiModalViewController else { return SemiModalViewController() }
        return vc
    }

    @IBOutlet private weak var contentView: UIView!
    
}

extension SemiModalViewController: SemiModalPresentationManagerDelegate {
    var semiModalContentHeight: CGFloat {
        return contentView.frame.height
    }
}
