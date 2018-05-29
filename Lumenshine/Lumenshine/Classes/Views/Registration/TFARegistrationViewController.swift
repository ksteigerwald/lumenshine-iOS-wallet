//
//  TFARegistrationViewController.swift
//  Lumenshine
//
//  Created by Istvan Elekes on 4/29/18.
//  Copyright © 2018 Soneso. All rights reserved.
//

import UIKit
import Material

class TFARegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let viewModel: TFARegistrationViewModelType
    
    // MARK: - UI properties
    fileprivate let authenticatorLabel = UILabel()
    fileprivate let openButton = RaisedButton()
    fileprivate let qrImageView = UIImageView()
    fileprivate let tfaCodeTextField = UITextField()
    fileprivate let submitButton = RaisedButton()
    
    init(viewModel: TFARegistrationViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground(notification:)), name: .UIApplicationWillEnterForeground, object: nil)
        prepareView()
//        prepareTimer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc
    func appWillEnterForeground(notification: Notification) {
        if UIPasteboard.general.hasStrings {
            if let tfaCode = UIPasteboard.general.string,
                tfaCode.count == 6,
                CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: tfaCode)) {
                tfaCodeTextField.text = tfaCode
            }
        }
    }
}

// MARK: - Actions
extension TFARegistrationViewController {
    @objc
    func openAction(sender: UIButton) {
        viewModel.openAuthenticator()
    }
    
    @objc
    func submitAction(sender: UIButton) {
        guard let code = tfaCodeTextField.text else { return }
        viewModel.submit(tfaCode: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tfaResponse):
                    if tfaResponse.mailConfirmed == false {
                        self.viewModel.showEmailConfirmation()
                    } else if tfaResponse.mnemonicConfirmed == false {
                        self.viewModel.showMnemonicConfirmation()
                    } else {
                        self.viewModel.showDashboard()
                    }
                case .failure(let error):
                    let alert = AlertFactory.createAlert(error: error)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

fileprivate extension TFARegistrationViewController {
    func prepareView() {
        view.backgroundColor = Stylesheet.color(.white)
        prepareLabel()
        prepareImageView()
        prepareOpenButton()
        prepareSubmitButton()
        prepareCodeTextField()
    }
    
    func prepareTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { (timer) in
            self.tfaCodeTextField.text = self.viewModel.generatePassword()
        }
        timer.fire()
    }
    
    func prepareLabel() {
        authenticatorLabel.text = R.string.localizable.lbl_tfa_secret_authenticator(viewModel.tfaSecret)
        authenticatorLabel.font = Stylesheet.font(.headline)
        authenticatorLabel.textAlignment = .center
        authenticatorLabel.numberOfLines = 0
        
        view.addSubview(authenticatorLabel)
        authenticatorLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
    }
    
    func prepareImageView() {
        guard let qrImgData = viewModel.qrCode else { return }
        qrImageView.image = UIImage(data: qrImgData)
        qrImageView.contentMode = .scaleAspectFit
        
        view.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(authenticatorLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(130)
        }
    }
    
    func prepareOpenButton() {
        openButton.title = R.string.localizable.open()
        openButton.backgroundColor = Stylesheet.color(.cyan)
        openButton.titleColor = Stylesheet.color(.white)
        openButton.addTarget(self, action: #selector(openAction(sender:)), for: .touchUpInside)
        
        view.addSubview(openButton)
        openButton.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(10)
            make.left.equalTo(authenticatorLabel)
            make.right.equalTo(authenticatorLabel)
            make.height.equalTo(45)
        }
    }
    
    func prepareCodeTextField() {
        
        tfaCodeTextField.placeholder = R.string.localizable.tfa_code()
        tfaCodeTextField.textAlignment = .center
        tfaCodeTextField.borderStyle = .roundedRect
        
        view.addSubview(tfaCodeTextField)
        tfaCodeTextField.snp.makeConstraints { make in
            make.left.equalTo(authenticatorLabel)
            make.right.equalTo(authenticatorLabel)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
            make.height.equalTo(60)
        }
    }
    
    func prepareSubmitButton() {
        submitButton.title = R.string.localizable.submit()
        submitButton.backgroundColor = Stylesheet.color(.cyan)
        submitButton.titleColor = Stylesheet.color(.white)
        submitButton.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(authenticatorLabel)
            make.right.equalTo(authenticatorLabel)
            make.height.equalTo(45)
            make.bottom.equalTo(-30)
        }
    }
    
}