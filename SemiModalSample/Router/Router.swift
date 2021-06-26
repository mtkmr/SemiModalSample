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
        guard
            let vc = UIStoryboard(name: "Map", bundle: nil).instantiateInitialViewController() as? SemiModalAnimatorViewController
        else {
            return
        }
        let nav = UINavigationController(rootViewController: vc)
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
