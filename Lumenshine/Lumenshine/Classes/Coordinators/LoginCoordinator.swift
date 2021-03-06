//
//  LoginCoordinator.swift
//  Lumenshine
//
//  Created by Soneso GmbH on 12/12/2018.
//  Munich, Germany
//  web: https://soneso.com
//  email: hi@soneso.com
//  Copyright © 2018 Soneso. All rights reserved.
//

import UIKit
import Material

class LoginCoordinator: CoordinatorType {
    var baseController: UIViewController
    unowned var mainCoordinator: MainCoordinator
    
    init(mainCoordinator: MainCoordinator, transition: Transition? = .showLogin) {
        self.mainCoordinator = mainCoordinator
        let viewModel = LoginViewModel()
        self.baseController = LoginViewController(viewModel: viewModel)
        viewModel.navigationCoordinator = self
        mainCoordinator.currentCoordinator = self
    }
    
    func performTransition(transition: Transition) {
        DispatchQueue.main.async {
            switch transition {
            case .showDashboard(let user):
                self.showDashboard(user: user)
            case .showLogin:
                self.showLogin()
            case .showSignUp:
                self.showSignUp()
            case .showForgotPassword:
                self.showLostPassword()
            case .showLost2fa:
                self.showLost2FA()
            case .showSuccess:
                self.showSuccess()
            case .showEmailConfirmation:
                self.showEmailConfirmation()
            case .showHeaderMenu(let items):
                self.showHeaderMenu(items: items)
            case .showPasswordHint(let hint, let attributedText):
                self.showPasswordHint(hint, attributedText: attributedText)
            case .showSetup(let user, let mnemonic, let tfaConfirmed, let mailConfirmed, let mnemonicConfirmed, let tfaSecret):
                self.showSetup(user: user, mnemonic: mnemonic, tfaConfirmed: tfaConfirmed, mailConfirmed: mailConfirmed, mnemonicConfirmed: mnemonicConfirmed, tfaSecret: tfaSecret)
            case .showTermsOfService:
                self.showTermsOfService()
            default:
                break
            }
        }
    }
}

fileprivate extension LoginCoordinator {
    func showHeaderMenu(items: [(String, String?)]) {
        let headerVC = HeaderMenuViewController(items: items)
        headerVC.delegate = self.baseController as? LoginViewController
        self.baseController.present(headerVC, animated: true)
    }
    
    func showDashboard(user: User) {
        let coordinator = MenuCoordinator(mainCoordinator: mainCoordinator, user: user)
        present(coordinator: coordinator)
    }
    
    func showLogin() {
        (baseController as! LoginViewController).showLogin()
    }
    
    func showSignUp() {
        (baseController as! LoginViewController).showSignUp()
    }
    
    func showLostPassword() {
        (baseController as! LoginViewController).showLostPassword()
    }
    
    func showLost2FA() {
        (baseController as! LoginViewController).showLost2FA()
    }
    
    func showSuccess() {
        (baseController as! LoginViewController).showSuccess()
    }
    
    func showEmailConfirmation() {
        (baseController as! LoginViewController).showEmailConfirmation()
    }
    
    func showPasswordHint(_ hint: String, attributedText: NSAttributedString?) {
        let title = R.string.localizable.password_hint_title()
        let textVC = InfoViewController(info: hint, attributedText: attributedText, title: title)
        let composeVC = ComposeNavigationController(rootViewController: textVC)
        baseController.present(composeVC, animated: true)
    }
    
    func showTermsOfService() {
        let textVC = TermsViewController()
        let composeVC = ComposeNavigationController(rootViewController: textVC)
        baseController.present(composeVC, animated: true)
    }
    
    func showSetup(user: User, mnemonic: String, tfaConfirmed: Bool, mailConfirmed: Bool, mnemonicConfirmed: Bool, tfaSecret: String?) {
        let coordinator = SetupMenuCoordinator(mainCoordinator: mainCoordinator, user: user, mnemonic: mnemonic, tfaConfirmed: tfaConfirmed, mailConfirmed: mailConfirmed, mnemonicConfirmed: mnemonicConfirmed, tfaSecret:tfaSecret)
        present(coordinator: coordinator)
    }
    
    func present(coordinator: CoordinatorType) {
        if let window = UIApplication.shared.delegate?.window ?? baseController.view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = coordinator.baseController
            }, completion: nil)
        }
    }
}

