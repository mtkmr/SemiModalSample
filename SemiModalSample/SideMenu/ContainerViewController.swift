//
//  ContainerViewController.swift
//  SemiModalSample
//
//  Created by Masato Takamura on 2021/06/27.
//

import UIKit

//全体を管理するコントローラ
class ContainerViewController: UIViewController {
    //menuの状態
    enum MenuState {
        case opened
        case closed
    }
    //menuの幅
    private lazy var slideMenuPadding: CGFloat = view.frame.width * 0.7
    //menuの状態をインスタンス化
    private var menuState: MenuState = .closed
    //ViewController
    let homeVC = HomeViewController()
    let menuVC = MenuViewController()
    lazy var infoVC = InfoViewController()
    lazy var appRatingVC = AppRatingViewController()
    lazy var shareAppVC = ShareAppViewController()
    lazy var settingVC = SettingsViewController()
    var homeNavVC: UINavigationController?

//    MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

    //    MARK: - functions
private extension ContainerViewController {
        
        //先に追加した方がz軸で下に来る
        private func addChildVCs() {
            //Menu
            menuVC.delegate = self
            addChild(menuVC)
            view.addSubview(menuVC.view)
            menuVC.didMove(toParent: self)
            //Home
            homeVC.delegate = self
            let navVC = UINavigationController(rootViewController: homeVC)
            addChild(navVC)
            view.addSubview(navVC.view)
            navVC.didMove(toParent: self)
            homeNavVC = navVC
        }
}

//MARK: - HomeViewControllerDelegate
extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func didTapCloseButton() {
        Router.shared.returnRoot(vc: self)
    }
    
    func didTapOverlay() {
        toggleMenu(completion: nil)
    }
    
    private func toggleMenu(completion: (() -> Void)?) {
        //menuを表示する
        switch menuState {
        case .closed:
            //menuを開く
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.homeNavVC?.view.frame.origin.x = self.slideMenuPadding
                self.homeVC.overlayView.isHidden = false
            }) { [weak self] (done) in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            //menuを閉じる
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.homeNavVC?.view.frame.origin.x = 0
                self.homeVC.overlayView.isHidden = true
            }) { [weak self] (done) in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

//MARK: - MenuViewControllerDelegate
extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem {
        case .home:
            resetToHome()
        case .info:
            //infoVCをchildViewControllerに追加する
            changeChild(to: infoVC)
        case .appRating:
            changeChild(to: appRatingVC)
        case .shareApp:
            changeChild(to: shareAppVC)
        case .settings:
            changeChild(to: settingVC)
        }
    }
    
    private func changeChild(to nextVC: UIViewController) {
        //remove
        if !homeVC.children.isEmpty {
            homeVC.children.forEach {
                $0.removeFromParent()
                $0.view.removeFromSuperview()
                $0.didMove(toParent: nil)
            }
        }
        //add
        homeVC.addChild(nextVC)
        homeVC.view.addSubview(nextVC.view)
        nextVC.view.frame = view.frame
        nextVC.didMove(toParent: homeVC)
        homeVC.title = nextVC.title
    }
    
    private func resetToHome() {
        homeVC.children.forEach {
            $0.removeFromParent()
            $0.view.removeFromSuperview()
            $0.didMove(toParent: nil)
            homeVC.title = "Home"
        }
    }
    
    
}
