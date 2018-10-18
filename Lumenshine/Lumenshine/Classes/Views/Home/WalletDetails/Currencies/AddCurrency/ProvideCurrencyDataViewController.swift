//
//  ProvideCurrencyDataViewController.swift
//  Lumenshine
//
//  Created by Soneso on 24/08/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

fileprivate enum AddButtonTitles: String {
    case add = "SUBMIT"
    case validating = "Validating & adding"
}

fileprivate enum AlphanumericTypesMaximumLength: Int {
    case alphanumeric4 = 4
    case alphanumeric12 = 12
}

class ProvideCurrencyDataViewController: UIViewController {
    @IBOutlet weak var currencyValidationStackView: UIStackView!
    @IBOutlet weak var issuerValidationStackView: UIStackView!
    
    @IBOutlet weak var assetCodeTextField: UITextField!
    @IBOutlet weak var publicKeyTextField: UITextField!
    
    @IBOutlet weak var issuerValidationLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var passwordViewContainer: UIView!
    
    var wallet: FundedWallet!
    private var walletManager = WalletManager()
    private var inputDataValidator = InputDataValidator()
    private var passwordView: PasswordView!
    private let IssuerDoesntExistValidationError = "Issuer does not exist"
    private let passwordManager = PasswordManager()
    private let userManager = UserManager()
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addCurrency()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.backgroundColor = Stylesheet.color(.blue)
        setupPasswordView()
    }
    
    private func addCurrency(forBiometricAuth biometricAuth: Bool = false) {
        resetValidationErrors()
        
        addButton.setTitle(AddButtonTitles.validating.rawValue, for: UIControlState.normal)
        addButton.isEnabled = false
        
        if isInputDataValid(forBiometricAuth: biometricAuth) {
            guard hasEnoughFunding else {
                self.showFundingAlert()
                return
            }
            
            validatePasswordAndDestination(forBiometricAuth: biometricAuth)
        } else {
            resetAddButtonToDefault()
        }
    }
    
    private func validatePasswordAndDestination(forBiometricAuth biometricAuth: Bool) {
        if let assetCode = assetCodeTextField.text, let issuer = publicKeyTextField.text {
            if passwordView.useExternalSigning {
                validateDestinationForExternalSigning(issuer: issuer, assetCode: assetCode)
            } else {
                validateDestinationAndPassword(issuer: issuer, assetCode: assetCode, biometricAuth: biometricAuth)
            }
        }
    }
    
    private func validateDestinationForExternalSigning(issuer: String, assetCode: String) {
        userManager.checkIfAccountExists(forAccountID: issuer) { (result) -> (Void) in
            if result {
                self.addTrustLine(issuer: issuer, assetCode: assetCode)
            } else {
                self.showValidationError(for: self.issuerValidationStackView)
                self.issuerValidationLabel.text = self.IssuerDoesntExistValidationError
                self.resetAddButtonToDefault()
            }
        }
    }
    
    private func validateDestinationAndPassword(issuer: String, assetCode: String, biometricAuth: Bool) {
        inputDataValidator.isPasswordAndDestinationAddresValid(address: issuer, password: !biometricAuth ? passwordView.passwordTextField.text : nil) { (passwordAndAddressResponse) -> (Void) in
            switch passwordAndAddressResponse {
            case .success(_):
                self.addTrustLine(issuer: issuer, assetCode: assetCode)
                
            case .failure(errorCode: let errorCode):
                switch errorCode {
                case .addressNotFound:
                    self.showValidationError(for: self.issuerValidationStackView)
                    self.issuerValidationLabel.text = self.IssuerDoesntExistValidationError
                    
                case .incorrectPassword:
                    self.passwordView.showInvalidPasswordError()
                    
                case .enterPasswordPressed:
                    break
                }
                
                self.resetAddButtonToDefault()
            }
        }
    }
    
    private func setupPasswordView() {
        passwordView = Bundle.main.loadNibNamed("PasswordView", owner: self, options: nil)![0] as? PasswordView
        passwordView.masterKeyNeededSecurity = .low
        passwordView.hideTitleLabels = true
        passwordView.wallet = wallet
        
        passwordView.biometricAuthAction = {
            self.addCurrency(forBiometricAuth: true)
        }
        
        passwordViewContainer.addSubview(passwordView)
        
        passwordView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func showValidationError(for stackView: UIStackView) {
        stackView.isHidden = false
    }
    
    private func resetValidationErrors() {
        currencyValidationStackView.isHidden = true
        issuerValidationStackView.isHidden = true
        passwordView.resetValidationErrors()
    }
    
    private func resetAddButtonToDefault() {
        addButton.setTitle(AddButtonTitles.add.rawValue, for: UIControlState.normal)
        addButton.isEnabled = true
    }
    
    private var isAddressValid: Bool {
        get {
            if let address = publicKeyTextField.text, address.isMandatoryValid() {
                if address.isBase64Valid() {
                    return true
                }
                
                showValidationError(for: issuerValidationStackView)
                issuerValidationLabel.text = ValidationErrors.InvalidAddress.rawValue
                return false
            } else {
                showValidationError(for: issuerValidationStackView)
                issuerValidationLabel.text = ValidationErrors.Mandatory.rawValue
            }
            
            return false
        }
    }
    
    private var isAssetCodeValid: Bool {
        get {
            if let assetCode = assetCodeTextField.text, assetCode.isAssetCodeValid() {
                return true
            }
            
            showValidationError(for: currencyValidationStackView)
            return false
        }
    }
    
    private func isPasswordValid(forBiometricAuth biometricAuth: Bool) -> Bool {
        return passwordView.validatePassword(biometricAuth: biometricAuth)
    }
    
    private func isInputDataValid(forBiometricAuth biometricAuth: Bool) -> Bool {
        let isAssetCodeValid = self.isAssetCodeValid
        let isAddressValid = self.isAddressValid
        let isPasswordValid = self.isPasswordValid(forBiometricAuth: biometricAuth)
        
        return isAssetCodeValid && isAddressValid && isPasswordValid
    }
    
    private var hasEnoughFunding: Bool {
        get {
            return walletManager.hasWalletEnoughFunding(wallet: wallet)
        }
    }
    
    private func showFundingAlert() {
        self.displaySimpleAlertView(title: "Adding failed", message: "Insufficient funding. Please send lumens to your wallet first.")
    }
    
    private func addTrustLine(issuer: String, assetCode: String) {
        let signer = passwordView.useExternalSigning ? passwordView.signersTextField.text : nil
        let seed = passwordView.useExternalSigning ? passwordView.seedTextField.text : nil
        let transactionHelper = TransactionHelper(wallet: wallet, signer: signer, signerSeed: seed)
        
        var assetType: Int32? = nil
        
        if assetCode.count <= AlphanumericTypesMaximumLength.alphanumeric4.rawValue {
            assetType = AssetType.ASSET_TYPE_CREDIT_ALPHANUM4
        } else {
            assetType = AssetType.ASSET_TYPE_CREDIT_ALPHANUM12
        }
        
        let issuerKeyPair = try? KeyPair(accountId: issuer)
        
        if let assetType = assetType,
            let issuerKeyPair = issuerKeyPair,
            let asset = Asset(type: assetType, code: assetCode, issuer: issuerKeyPair) {
            
            transactionHelper.addTrustLine(asset: asset, completion: { (status) -> (Void) in
                switch status {
                case .success:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self.resetAddButtonToDefault()
                }
                
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
