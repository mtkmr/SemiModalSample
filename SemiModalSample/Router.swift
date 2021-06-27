//
//  Router.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/24.
//

import UIKit

final class Router {
    static let shared = Router()
    private init() {}
    
    private var window: UIWindow?
    
    ///起動画面を表示する
    func showRoot(window: UIWindow?) {
        let baseVC = BaseViewController.makeFromStoryboard()
        let nav = UINavigationController(rootViewController: baseVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        self.window = window
    }
    
}

private extension Router {
    func show(from: UIViewController, to next: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(next, animated: animated)
        } else {
            from.present(next, animated: animated, completion: nil)
        }
    }
}
