//
//  BaseViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/26.
//

import UIKit

final class BaseViewController: UIViewController {
    static func makeFromStoryboard() -> BaseViewController {
        guard let vc = UIStoryboard.init(name: "Base", bundle: nil).instantiateInitialViewController() as? BaseViewController else { return BaseViewController() }
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Semi Modal Sample"
    }
}
