//
//  SetupCoordinator.swift
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
import KWDrawerController

class SetupCoordinator: CoordinatorType {
    var baseController: UIViewController
    unowned var mainCoordinator: MainCoordinator
    fileprivate let viewModel: SetupViewModel
    fileprivate let user: User
    
    init(mainCoordinator: MainCoordinator, user: User, mnemonic: String, tfaConfirmed: Bool, mailConfirmed: Bool, mnemonicConfirmed: Bool, tfaSecret:String?) {
        self.user = user
        self.mainCoordinator = mainCoordinator
        self.viewModel = SetupViewModel(user: user, mnemonic: mnemonic, tfaConfirmed: tfaConfirmed, mailConfirmed: mailConfirmed, mnemonicConfirmed: mnemonicConfirmed, tfaSecret:tfaSecret)
        if let setup = SetupViewController.initialize(viewModel: viewModel) {
            self.baseController = SnackbarController(rootViewController: setup)
            viewModel.navigationCoordinator = self
        } else {
            self.baseController = SetupViewController(viewModel: viewModel)
            showDashboard()
        }
        mainCoordinator.currentCoordinator = self
    }
    
    func performTransition(transition: Transition) {
        switch transition {
        case .nextSetupStep:
            nextSetupStep()
        case .showMnemonicVerification:
            showMnemonicVerification()
        case .showRelogin:
            showRelogin()
        default: break
        }
    }
}

fileprivate extension SetupCoordinator {
    func nextSetupStep() {
        if let setup = SetupViewController.initialize(viewModel: viewModel) {
            let baseVC = SnackbarController(rootViewController: setup)
            present(viewController: baseVC)
        } else {
            showDashboard()
        }
    }
    
    func showMnemonicVerification() {
        let setup = VerificationSetupViewController(viewModel: viewModel)
        let baseVC = SnackbarController(rootViewController: setup)
        present(viewController: baseVC)
    }
    
    func showDashboard() {
        let coordinator = MenuCoordinator(mainCoordinator: mainCoordinator, user: user)
        present(coordinator: coordinator)
    }
    
    func showRelogin() {
        let coordinator = ReLoginMenuCoordinator(mainCoordinator: mainCoordinator, user: user)
        present(coordinator: coordinator)
    }
    
    func present(viewController: UIViewController) {
        if let menu = baseController.drawerController?.getViewController(for: .left) as? MenuViewController {
            menu.present(viewController)
        }
        baseController.navigationController?.setViewControllers([viewController], animated: true)
        baseController = viewController
    }
    
    func present(coordinator: CoordinatorType) {
        if let window = UIApplication.shared.delegate?.window ?? baseController.view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {
                window.rootViewController = coordinator.baseController
            }, completion: nil)
        }
    }
}
