//
//  KnownCurrenciesTableViewCell.swift
//  Lumenshine
//
//  Created by Soneso GmbH on 12/12/2018.
//  Munich, Germany
//  web: https://soneso.com
//  email: hi@soneso.com
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

fileprivate enum AddButtonTitles: String {
    case add = "SUBMIT"
    case validatingAndAdding = "validating & adding"
}

class KnownCurrenciesTableViewCell: UITableViewCell {
    static var isReloading: (String, Bool) = ("", false)
    @IBOutlet weak var assetCodeLabel: UILabel!
    @IBOutlet weak var authorizationLabel: UILabel!
    @IBOutlet weak var issuerPublicKeyLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var expansionView: UIView!
    @IBOutlet weak var authorizationView: UIView!
    @IBOutlet weak var passwordViewContainer: UIView!
    
    var wallet: FundedWallet! {
        didSet {
            setupPasswordView()
        }
    }
    
    var canWalletSign: Bool!
    var cellIndexPath: IndexPath!
    var passwordView: PasswordView!
    private let walletManager = WalletManager()
    private let passwordManager = PasswordManager()
    
    private var authService: AuthService {
        get {
            return Services.shared.auth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addCurrency()
    }
    
    func expand() {
        expansionView.isHidden = false
    }
    
    func collapse() {
        expansionView.isHidden = true
    }
    
    private func addCurrency(biometricAuth: Bool = false, limit: Decimal? = nil) {
        passwordView.resetValidationErrors()
        setButtonAsValidating()
        
        if isPasswordValid(biometricAuth: biometricAuth), let assetCode = assetCodeLabel.text?.getAssetCode(), let issuerAccountId = issuerPublicKeyLabel.text, let issuerKeyPair = try? KeyPair(accountId: issuerAccountId) {
            guard hasEnoughFunding else {
                showFundingAlert()
                setButtonAsNormal()
                return
            }
            
            if passwordView.useExternalSigning {
                let trustorKeyPair = try! KeyPair(publicKey: PublicKey(accountId:wallet.publicKey), privateKey:nil)
                self.addTrustLine(assetCode: assetCode, trustingAccountKeyPair:trustorKeyPair, issuerKeyPair: issuerKeyPair, limit:limit)
            } else {
                validatePasswordAndAddCurrency(biometricAuth: biometricAuth, assetCode: assetCode, issuerKeyPair: issuerKeyPair, limit:limit)
            }
            
        } else {
            setButtonAsNormal()
        }
    }
    
    private func validatePasswordAndAddCurrency(biometricAuth: Bool, assetCode: String, issuerKeyPair: KeyPair, limit:Decimal?) {
        passwordManager.getMnemonic(password: !biometricAuth ? passwordView.passwordTextField.text : nil) { (result) -> (Void) in
            switch result {
            case .success(mnemonic: let mnemonic):
                PrivateKeyManager.getKeyPair(forAccountID: self.wallet.publicKey, fromMnemonic: mnemonic) { (response) -> (Void) in
                    switch response {
                    case .success(keyPair: let keyPair):
                        if let trustorKeyPair = keyPair {
                            self.addTrustLine(assetCode: assetCode, trustingAccountKeyPair:trustorKeyPair, issuerKeyPair: issuerKeyPair, limit:limit)
                            return
                        }
                    case .failure(error: let error):
                        print(error)
                    }
                    DispatchQueue.main.async {
                        self.showSigningAlert()
                        self.setButtonAsNormal()
                    }
                }
                
            case .failure(error: let error):
                print("Get mnemonic error: \(error)")
                DispatchQueue.main.async {
                    self.passwordView.showInvalidPasswordError()
                    self.setButtonAsNormal()
                }
            }
        }
    }
    
    private func isPasswordValid(biometricAuth: Bool) -> Bool {
        return passwordView.validatePassword(biometricAuth: biometricAuth)
    }
    
    private var hasEnoughFunding: Bool {
        get {
            return walletManager.hasWalletEnoughFunding(wallet: wallet)
        }
    }
    
    private func dissmissView() {
        viewContainingController()?.navigationController?.popViewController(animated: true)
    }
    
    private func showFundingAlert() {
        parentContainerViewController()?.displaySimpleAlertView(title: "Adding failed", message: "Insufficient funding. Please send lumens to your wallet first.")
    }
    
    private func showSigningAlert() {
        parentContainerViewController()?.displaySimpleAlertView(title: "Adding failed", message: "A signing error occured.")
    }
    
    private func showTrnsactionFailedAlert() {
        parentContainerViewController()?.displaySimpleAlertView(title: "Adding failed", message: "A transaction error occured.")
    }
    
    private func setButtonAsValidating() {
        addButton.setTitle(AddButtonTitles.validatingAndAdding.rawValue, for: UIControl.State.normal)
        addButton.isEnabled = false
    }
    
    private func setButtonAsNormal() {
        addButton.setTitle(AddButtonTitles.add.rawValue, for: UIControl.State.normal)
        addButton.isEnabled = true
    }
    
    private func addTrustLine(assetCode: String, trustingAccountKeyPair:KeyPair, issuerKeyPair: KeyPair, limit:Decimal?) {
        let assetType: Int32 = assetCode.count < 5 ? AssetType.ASSET_TYPE_CREDIT_ALPHANUM4 : AssetType.ASSET_TYPE_CREDIT_ALPHANUM12
        if let asset = Asset(type: assetType, code: assetCode, issuer: issuerKeyPair) {
            let signer = passwordView.useExternalSigning ? passwordView.signersTextField.text : nil
            let seed = passwordView.useExternalSigning ? passwordView.seedTextField.text : nil
   
            let transactionHelper = TransactionHelper(wallet: wallet, signer: signer, signerSeed: seed)
            passwordView.clearSeedAndPasswordFields()
            transactionHelper.addTrustLine(trustingAccountKeyPair:trustingAccountKeyPair, asset:asset, limit: limit) { (result) -> (Void) in
                switch result {
                case .success:
                    Services.shared.walletService.addWalletToRefresh(accountId: self.wallet.publicKey)
                    NotificationCenter.default.post(name: .refreshWalletsNotification, object: false)
                    self.dissmissView()
                    break
                case .failure(error: let error):
                    print("Error: \(String(describing: error))")
                    self.showTrnsactionFailedAlert()
                    self.setButtonAsNormal()
                }
            }
        }
    }
    
    private func setupView() {
        backgroundColor = Stylesheet.color(.clear)
        authorizationLabel.textColor = Stylesheet.color(.red)
        addButton.backgroundColor = Stylesheet.color(.blue)
    }
    
    func setupPasswordView() {
        passwordView = Bundle.main.loadNibNamed("PasswordView", owner: self, options: nil)![0] as? PasswordView
        passwordView.neededSigningSecurity = .medium
        passwordView.externalSetup = true
        passwordView.hideTitleLabels = true
        passwordView.alwaysShowValidationPlaceholders = true
        passwordView.wallet = wallet
        passwordView.passwordHintView.isHidden = false
        passwordView.passwordHintLabel.text = "Password required to add currency"
        
        passwordView.biometricAuthAction = {
            self.addCurrency(biometricAuth: true)
        }
        
        if canWalletSign {
            passwordView.showPassword()
        } else {
            passwordView.showSigners()
        }
        
        passwordViewContainer.addSubview(passwordView)
        
        passwordView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subView in passwordViewContainer.subviews {
            subView.removeFromSuperview()
        }

        passwordView = nil
    }
}
