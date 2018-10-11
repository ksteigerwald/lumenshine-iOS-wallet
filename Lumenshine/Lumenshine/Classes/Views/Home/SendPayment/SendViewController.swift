//
//  SendViewController.swift
//  Lumenshine
//
//  Created by Soneso on 02/08/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk
import Material

enum ValidationErrors: String {
    case Mandatory = "Mandatory"
    case InvalidAddress = "Invalid public key or address"
    case InvalidMemo = "Invalid memo"
    case MemoLength = "Memo is too long"
    case InsufficientLumens = "Insufficient XLM for transaction fee available"
    case RecipientAccount = "Warning: Recipient account does not exist or is not funded"
    case CurrencyNoTrust = "Recipient can not receive selected currency"
    case AddressNotFound = "Address not found"
    case InvalidPassword = "Invalid password"
    case MandatoryPassword = "Password required"
    case InvalidSignerSeed = "Invalid seed"
    case InvalidAmount = "Invalid amount"
    case InvalidAssetCode = "Invalid asset code"
    case FederationNotFound = "Could not find stellar address"
}

enum MemoTypeValues: String {
    case MEMO_TEXT = "MEMO_TEXT"
    case MEMO_ID = "MEMO_ID"
    case MEMO_HASH = "MEMO_HASH"
    case MEMO_RETURN = "MEMO_RETURN"
}

enum MemoTextFieldPlaceholders: String {
    case MemoText = "Up to 28 characters"
    case MemoID = "Enter memo ID number"
    case MemoReturn = "Enter 64 characters encoded string"
}

enum NativeCurrencyNames: String {
    case xlm = "XLM"
    case stellarLumens = "Stellar Lumens (XLM)"
}

enum SendButtonTitles: String {
    case sendAnyway = "Send anyway"
    case validating = "Validating and sending"
}

enum AmountSegmentedControlIndexes: Int {
    case sendAmount = 0
    case sendAll = 1
}

public let MaximumLengthInBytesForMemoText = 28
public let QRCodeSeparationString = " "
public let QRCodeNativeCurrencyIssuer = "native"
public let OtherCurrencyText = "Other"

class SendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, WalletActionsProtocol, ScanViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var currentCurrencyLabel: UILabel!
    @IBOutlet weak var addressErrorLabel: UILabel!
    @IBOutlet weak var amountErrorLabel: UILabel!
    @IBOutlet weak var memoInputErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var sendErrorLabel: UILabel!
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var sendAllCurrency: UILabel!
    @IBOutlet weak var sendAllValue: UILabel!
    @IBOutlet weak var seedErrorLabel: UILabel!
    @IBOutlet weak var otherCurrencyErrorLabel: UILabel!
    
    @IBOutlet weak var memoTypeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var memoInputTextField: UITextField!
    @IBOutlet weak var issuerTextField: UITextField!
    @IBOutlet weak var currentCurrencyTextField: UITextField!
    @IBOutlet weak var signerTextField: UITextField!
    @IBOutlet weak var signerSeedTextField: UITextField!
    @IBOutlet weak var otherCurrencyTextField: UITextField!
    
    @IBOutlet weak var seedErrorView: UIView!
    @IBOutlet weak var addressErrorView: UIView!
    @IBOutlet weak var amountErrorView: UIView!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var sendErrorView: UIView!
    @IBOutlet weak var memoInputErrorView: UIView!
    @IBOutlet weak var issuerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var sendAllView: UIView!
    @IBOutlet weak var sendAmountView: UIView!
    @IBOutlet weak var availableAmountView: UIView!
    @IBOutlet weak var otherCurrencyView: UIView!
    @IBOutlet weak var otherCurrencyErrorView: UIView!
    @IBOutlet weak var biometricAuthView: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var biometricAuthButton: UIButton!
    
    @IBOutlet weak var amountSegmentedControl: UISegmentedControl!

    @IBOutlet weak var signerStackView: UIStackView!
    @IBOutlet weak var passwordStackView: UIStackView!
    
    private var currencyPickerView: UIPickerView!
    private var issuerPickerView: UIPickerView!
    private var memoTypePickerView: UIPickerView!
    private var signerPickerView: UIPickerView!
    
    private var isInputDataValid: Bool = true
    private var isSendAnywayRequired = false
    private var userMnemonic: String!
    private var availableAmount: CoinUnit?
    private var availableSigners: [AccountSignerResponse]!
    private var otherCurrencyAsset: AccountBalanceResponse?
    
    private var scanViewController: ScanViewController!
    private let inputDataValidator = InputDataValidator()
    private let userManager = UserManager()
    private let passwordManager = PasswordManager()
    
    var wallet: Wallet!
    var closeAction: (() -> ())?
    var sendAction: ((TransactionInput) -> ())?
    
    private var memoTypes: [MemoTypeValues] = [MemoTypeValues.MEMO_TEXT, MemoTypeValues.MEMO_ID, MemoTypeValues.MEMO_HASH, MemoTypeValues.MEMO_RETURN]
    
    @IBAction func amountSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        if amountSegmentedControl.selectedSegmentIndex == AmountSegmentedControlIndexes.sendAmount.rawValue {
            sendAmountView.isHidden = false
            sendAllView.isHidden = true
            availableAmount = nil
        } else if amountSegmentedControl.selectedSegmentIndex == AmountSegmentedControlIndexes.sendAll.rawValue{
            sendAmountView.isHidden = true
            sendAllView.isHidden = false
            amountErrorView.isHidden = true
            setAvailableAmount()
        }
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        sendActionPreparation()
    }

    @IBAction func biometricAuthAction(_ sender: UIButton) {
        sendActionPreparation(biometricAuth: true)
    }
    
    private func sendActionPreparation(biometricAuth: Bool = false) {
        resetValidations()
        sendButton.setTitle(SendButtonTitles.validating.rawValue, for: UIControlState.normal)
        sendButton.isEnabled = false
        if validateInsertedData(biometricAuth: biometricAuth) {
            if passwordStackView.isHidden {
                validateInputForExternalSigning()
            } else {
                validateInputForMasterKey(biometricAuth: biometricAuth)
            }
        }
        else {
            resetSendButtonToNormal()
        }
    }
    
    private func validateInputForMasterKey(biometricAuth: Bool) {
        if let address = addressTextField.text {
            let password = !biometricAuth ? passwordTextField.text : nil
            if otherCurrencyView.isHidden, let currency = getSelectedCurrency() {
                validatePasswordAndDestinationAddress(address: address, password: password, currency: currency)
            } else {
                userManager.getAccountBalanceResponse(forAccount: address, forAssetCode: selectedCurrency, forAssetIssuer: wallet.publicKey) { (response) -> (Void) in
                    switch (response) {
                    case .success(currency: let currencyResponse):
                        let currency = currencyResponse
                        self.validatePasswordAndDestinationAddress(address: address, password: password, currency: currency)
                        self.otherCurrencyAsset = currency
                    case .failure(error: let error):
                        print("Currency asset code error: \(error)")
                        self.setValidationError(view: self.otherCurrencyErrorView, label: self.otherCurrencyErrorLabel, errorMessage: .InvalidAssetCode)
                        self.setSendButtonDefaultTitle()
                    }
                }
            }
        }
    }
    
    private func validateInputForExternalSigning() {
        if let address = addressTextField.text {
            if otherCurrencyView.isHidden, let currency = getSelectedCurrency() {
                isDestinationAddressValid(address: address, currency: currency)
            } else {
                userManager.getAccountBalanceResponse(forAccount: address, forAssetCode: selectedCurrency, forAssetIssuer: wallet.publicKey) { (response) -> (Void) in
                    switch (response) {
                    case .success(currency: let currencyResponse):
                        let currency = currencyResponse
                        self.isDestinationAddressValid(address: address, currency: currency)
                        self.otherCurrencyAsset = currency
                    case .failure(error: let error):
                        print("Currency asset code error: \(error)")
                        self.setValidationError(view: self.otherCurrencyErrorView, label: self.otherCurrencyErrorLabel, errorMessage: .InvalidAssetCode)
                        self.setSendButtonDefaultTitle()
                    }
                }
            }
        }
    }
    
    private func validatePasswordAndDestinationAddress(address: String, password: String?, currency: AccountBalanceResponse) {
        inputDataValidator.validatePasswordAndDestinationAddress(address: address, password: password, currency: currency) { (result) -> (Void) in
            switch result {
            case .success(passwordResponse: let passwordResponse, addressResponse: let addressResponse):
                self.validatePasswordResponse(passwordResponse: passwordResponse)
                self.validateAddressResponse(addressResponse: addressResponse)
                self.sendPaymentIfValid()
                
            case .failure(errorCode: let errorCode):
                switch errorCode {
                case .addressNotFound:
                    self.setValidationError(view: self.addressErrorView, label: self.addressErrorLabel, errorMessage: .AddressNotFound)
                    self.setSendButtonDefaultTitle()
                case .incorrectPassword:
                    self.setValidationError(view: self.passwordErrorView, label: self.passwordErrorLabel, errorMessage: .InvalidPassword)
                    self.setSendButtonDefaultTitle()
                case .enterPasswordPressed:
                    break
                }
            }
        }
    }

    private func isDestinationAddressValid(address: String, currency: AccountBalanceResponse) {
        inputDataValidator.isDestinationAddressValid(address: address, currency: currency) { (response) -> (Void) in
            self.validateAddressResponse(addressResponse: response)
            self.sendPaymentIfValid()
        }
    }
    
    private func getSelectedCurrency() -> AccountBalanceResponse? {
        return (wallet as! FundedWallet).balances.first(where: { (currency) -> Bool in
            if selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                return currency.displayCode == selectedCurrency
            }
            
            return currency.displayCode == selectedCurrency && currency.assetIssuer == issuerTextField.text})
    }
    
    private func sendPaymentIfValid() {
        if isInputDataValid {
            sendPayment()
        } else {
            resetSendButtonToNormal()
        }
    }
    
    @objc func addressChanged(_ textField: UITextField) {
        if isSendAnywayRequired {
            setSendButtonDefaultTitle()
            isSendAnywayRequired = false
        }
    }
    
    @objc func otherCurrencyChanged(_ textField: UITextField) {
        selectedCurrency = otherCurrencyTextField.text ?? ""
        currentCurrencyLabel.text = selectedCurrency
        setSendButtonDefaultTitle()
        validateAssetCode()
    }
    
    private var selectedMemoType: MemoTypeValues! = MemoTypeValues.MEMO_TEXT {
        didSet {
            memoTypeTextField.text = selectedMemoType.rawValue
            
            switch selectedMemoType.rawValue {
            case MemoTypeValues.MEMO_TEXT.rawValue:
                memoInputTextField.placeholder = MemoTextFieldPlaceholders.MemoText.rawValue
                memoInputTextField.keyboardType = .default
    
            case MemoTypeValues.MEMO_ID.rawValue:
                memoInputTextField.placeholder = MemoTextFieldPlaceholders.MemoID.rawValue
                memoInputTextField.keyboardType = .numberPad

            case MemoTypeValues.MEMO_HASH.rawValue:
                memoInputTextField.placeholder = MemoTextFieldPlaceholders.MemoReturn.rawValue
                memoInputTextField.keyboardType = .default
                
            case MemoTypeValues.MEMO_RETURN.rawValue:
                memoInputTextField.placeholder = MemoTextFieldPlaceholders.MemoReturn.rawValue
                memoInputTextField.keyboardType = .default
                
            default:
                break
            }
        }
    }
    
    private var selectedCurrency: String = "" {
        didSet {
            if !otherCurrencyView.isHidden {
                return
            }
            
            currentCurrencyLabel.text = selectedCurrency
            
            let currencyIssuer = (wallet as! FundedWallet).balances.first { (currency) -> Bool in
                return currency.assetCode == selectedCurrency
            }?.assetIssuer
            
            if selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                currentCurrencyTextField.text = nil
                currentCurrencyTextField.insertText(NativeCurrencyNames.stellarLumens.rawValue)
            } else {
                currentCurrencyTextField.text = nil
                currentCurrencyTextField.insertText(selectedCurrency)
            }
            
            setSendButtonDefaultTitle()
            
            if (wallet as! FundedWallet).isCurrencyDuplicate(withAssetCode: selectedCurrency) {
                if issuerPickerView == nil {
                    issuerPickerView = UIPickerView()
                    issuerPickerView.delegate = self
                    issuerPickerView.dataSource = self
                    issuerTextField.inputView = issuerPickerView
                    issuerTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(issuerDoneButtonTap))
                }
                
                issuerView.isHidden = false
            } else {
                issuerView.isHidden = true
            }
            
            if let currencyIssuer = currencyIssuer {
                issuerTextField.text = nil
                issuerTextField.insertText(currencyIssuer)
            }
            
            setAvailableAmount()
        }
    }
    
    private func showQRScanner() {
        scanViewController = ScanViewController()
        scanViewController.delegate = self
        navigationController?.pushViewController(scanViewController, animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupMemoTypePicker()
        addressTextField.addTarget(self, action: #selector(addressChanged), for: .editingChanged)
        view.backgroundColor = Stylesheet.color(.veryLightGray)
        sendButton.backgroundColor = Stylesheet.color(.blue)
        checkIfAccountCanSign()
        
        if !BiometricHelper.isBiometricAuthEnabled {
            hideBiometricAuthButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableCurrencies = (wallet as! FundedWallet).getAvailableCurrencies()
        if selectedCurrency.isEmpty {
            selectedCurrency = availableCurrencies.first!
        }
        
        checkForTransactionFeeAvailability()
        resetSendButtonToNormal()
    }
    
    private func setupForOtherCurrency() {
        currentCurrencyTextField.text = nil
        currentCurrencyTextField.insertText(OtherCurrencyText)
        availableAmountView.isHidden = true
        otherCurrencyView.isHidden = false
        amountSegmentedControl.selectedSegmentIndex = AmountSegmentedControlIndexes.sendAmount.rawValue
        sendAmountView.isHidden = false
        sendAllView.isHidden = true
        availableAmount = nil
        amountSegmentedControl.isEnabled = false
        
        selectedCurrency = ""
        currentCurrencyLabel.text = selectedCurrency
        setSendButtonDefaultTitle()
        
        otherCurrencyTextField.addTarget(self, action: #selector(otherCurrencyChanged), for: .editingChanged)
    }
    
    private func setupForSelectedCurrency() {
        if !otherCurrencyView.isHidden {
            otherCurrencyAsset = nil
            availableAmountView.isHidden = false
            otherCurrencyView.isHidden = true
            amountSegmentedControl.isEnabled = true
            resetOtherCurrencyValidationError()
            otherCurrencyTextField.text = nil
            otherCurrencyTextField.removeTarget(self, action: #selector(otherCurrencyChanged), for: .editingChanged)
        }
    }
    
    private func checkIfAccountCanSign() {
        userManager.canAccountSign(accountID: wallet.publicKey) { (response) -> (Void) in
            switch response {
            case .success(canSign: let canSign):
                if !canSign {
                    self.passwordStackView.isHidden = true
                    self.signerStackView.isHidden = false
                    self.hideBiometricAuthButton()
                    self.setupSigners()
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupSigners() {
        userManager.getSignersList(accountID: wallet.publicKey) { (response) -> (Void) in
            switch response {
            case .success(signersList: let signersList):
                if signersList.count == 1 {
                    self.showNoMultiSigSupportError()
                } else {
                    self.setupSignersPicker(signerList: signersList)
                }
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showNoMultiSigSupportError() {
        navigationController?.popViewController(animated: false)
        let noMultiSigSupportViewController = NoMultiSigSupportViewController()
        navigationController?.pushViewController(noMultiSigSupportViewController, animated: true)
    }
    
    private func setupSignersPicker(signerList: [AccountSignerResponse]) {
        if let masterKeyWeight = (wallet as? FundedWallet)?.masterKeyWeight {
            availableSigners = signerList.filter({ (signer) -> Bool in
                return signer.weight > masterKeyWeight
            })
        }
        
        
        signerPickerView = UIPickerView()
        signerPickerView.delegate = self
        signerPickerView.dataSource = self
        signerTextField.text = availableSigners.first?.publicKey
        signerTextField.inputView = signerPickerView
        signerTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(signerDoneButtonTap))
    }
    
    private func setupMemoTypePicker() {
        memoTypePickerView = UIPickerView()
        memoTypePickerView.delegate = self
        memoTypePickerView.dataSource = self
        memoTypeTextField.text = selectedMemoType.rawValue
        memoTypeTextField.inputView = memoTypePickerView
        memoTypeTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(memoTypeDoneButtonTap))
    }
    
    private func setAvailableLabels(currency: AccountBalanceResponse) {
        if let balance = CoinUnit(currency.balance) {
            let availableAmount = currency.assetCode != nil ? balance : balance.availableAmount(forWallet: wallet)
            availableAmountLabel.text = "You have \(availableAmount) \(selectedCurrency) available"
            
            if amountSegmentedControl.selectedSegmentIndex == AmountSegmentedControlIndexes.sendAll.rawValue {
                setSendAllLabel(amount: availableAmount)
            }
        }
    }
    
    private func setAvailableAmount() {
        for currency in (wallet as! FundedWallet).uniqueAssetCodeBalances {
            if selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                setAvailableLabels(currency: currency)
            } else if let currencyIssuer = issuerTextField.text,
                currency.assetIssuer == currencyIssuer,
                currency.assetCode == selectedCurrency {
                setAvailableLabels(currency: currency)
            }
        }
    }
    
    private var availableCurrencies: [String] = [""] {
        didSet {
            currencyPickerView = UIPickerView()
            currencyPickerView.delegate = self
            currencyPickerView.dataSource = self
            currentCurrencyTextField.inputView = currencyPickerView
            currentCurrencyTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(currencyDoneButtonTap))
            availableCurrencies.append(OtherCurrencyText)
        }
    }
    
    private func setSendAllLabel(amount: CoinUnit) {
        sendAllValue.text = "\(amount)"
        sendAllCurrency.text = selectedCurrency
        availableAmount = amount
    }
    
    @objc func currencyDoneButtonTap(_ sender: Any) {
        selectAsset(pickerView: currencyPickerView, row: currencyPickerView.selectedRow(inComponent: 0))
    }
    
    @objc func memoTypeDoneButtonTap(_ sender: Any) {
        selectAsset(pickerView: memoTypePickerView, row: memoTypePickerView.selectedRow(inComponent: 0))
    }
    
    @objc func issuerDoneButtonTap(_ sender: Any) {
        selectAsset(pickerView: issuerPickerView, row: issuerPickerView.selectedRow(inComponent: 0))
    }
    
    @objc func signerDoneButtonTap(_ sender: Any) {
        selectAsset(pickerView: signerPickerView, row: signerPickerView.selectedRow(inComponent: 0))
    }
    
    private func sendPayment() {
        let transactionData = TransactionInput(currency: self.selectedCurrency,
                                               issuer: self.issuerTextField.text ?? nil,
                                               address: self.addressTextField.text ?? "",
                                               amount: availableAmount != nil ? String(availableAmount!) : (self.amountTextField.text ?? ""),
                                               memo: self.memoInputTextField.text?.isEmpty == false ? self.memoInputTextField.text! : nil,
                                               memoType: self.memoTypes.first(where: { (memoType) -> Bool in
                                                if let memoTypeTextFieldValue = self.memoTypeTextField.text {
                                                    return memoType.rawValue == memoTypeTextFieldValue
                                                }
                                                
                                                return memoType.rawValue == MemoTypeValues.MEMO_TEXT.rawValue
                                               }),
                                               userMnemonic: self.userMnemonic,
                                               transactionType: !self.isSendAnywayRequired ? TransactionActionType.sendPayment : TransactionActionType.createAndFundAccount,
                                               signer: !self.signerStackView.isHidden ? self.signerTextField.text : nil,
                                               signerSeed: !self.signerStackView.isHidden ? self.signerSeedTextField.text : nil,
                                               otherCurrencyAsset: self.otherCurrencyAsset ?? nil)
        self.clearSeedAndPasswordFields()
        self.sendAction?(transactionData)
    }
    
    private func clearSeedAndPasswordFields() {
        signerSeedTextField.text = nil
        passwordTextField.text = nil
    }
    
    private func validatePasswordResponse(passwordResponse: PasswordEnum) {
        switch passwordResponse {
        case .success(mnemonic: let mnemonic):
            self.userMnemonic = mnemonic
        case .failure(error: let error):
            print("Error: \(error)")
            self.setValidationError(view: self.passwordErrorView, label: self.passwordErrorLabel, errorMessage: .InvalidPassword)
        }
    }
    
    private func validateAddressResponse(addressResponse: AddressStatusEnum) {
        switch addressResponse {
        case .success(isFunded: let isFunded, isTrusted: let isTrusted):
            if !isFunded {
                if self.isSendAnywayRequired && self.selectedCurrency == NativeCurrencyNames.xlm.rawValue{
                    self.checkForRecipientAccount()
                    return
                }
                
                self.setValidationError(view: self.sendErrorView, label: self.sendErrorLabel, errorMessage: .RecipientAccount)
                
                if self.selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                    self.isSendAnywayRequired = true
                }
            } else if let isTrusted = isTrusted, !isTrusted {
                self.setValidationError(view: self.addressErrorView, label: self.addressErrorLabel, errorMessage: .CurrencyNoTrust)
            }
            
        case .failure:
            print("Account not found")
            if self.selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                if addressTextField.text?.isFederationAddress() == true {
                    self.setValidationError(view: self.sendErrorView, label: self.sendErrorLabel, errorMessage: .FederationNotFound)
                    return
                }
                
                if self.isSendAnywayRequired {
                    self.checkForRecipientAccount()
                    return
                }
                
                self.setValidationError(view: self.sendErrorView, label: self.sendErrorLabel, errorMessage: .RecipientAccount)
                self.isSendAnywayRequired = true
            } else {
                self.setValidationError(view: self.addressErrorView, label: self.addressErrorLabel, errorMessage: .AddressNotFound)
            }
        }
    }
    
    private func getSendButtonDefaultTitle() -> String {
        return "SEND \(selectedCurrency)"
    }
    
    private func setSendButtonDefaultTitle() {
        let sendButtonTitle: String = getSendButtonDefaultTitle()
        sendButton.setTitle(sendButtonTitle, for: .normal)
        
        if !sendButton.isEnabled {
            sendButton.isEnabled = true
        }
    }
    
    private func checkForTransactionFeeAvailability() {
        if (wallet as! FundedWallet).nativeBalance.availableAmount(forWallet: wallet).isLess(than: CoinUnit.minimumReserved(forWallet: wallet)) {
            sendErrorView.isHidden = false
            sendErrorLabel.text = ValidationErrors.InsufficientLumens.rawValue
            sendButton.isEnabled = false
        }
    }
    
    private func resetValidations() {
        addressErrorView.isHidden = true
        addressErrorLabel.text = nil
        amountErrorView.isHidden = true
        amountErrorLabel.text = nil
        memoInputErrorView.isHidden = true
        memoInputErrorLabel.text = nil
        passwordErrorView.isHidden = true
        passwordErrorLabel.text = nil
        sendErrorView.isHidden = true
        sendErrorLabel.text = nil
        seedErrorView.isHidden = true
        seedErrorLabel.text = nil
        otherCurrencyErrorView.isHidden = true
        otherCurrencyErrorLabel.text = nil
        isInputDataValid = true
        setSendButtonDefaultTitle()
    }
    
    private func setValidationError(view: UIView, label: UILabel, errorMessage: ValidationErrors) {
        view.isHidden = false
        label.text = errorMessage.rawValue
        isInputDataValid = false
        
        contentView.setContentOffset(CGPoint(x: 0, y: view.frame.center.y), animated: false)
    }
    
    private func resetOtherCurrencyValidationError() {
        otherCurrencyAsset = nil
        otherCurrencyErrorLabel.text = nil
        otherCurrencyErrorView.isHidden = true
        isInputDataValid = true
    }
    
    private func validateAssetCodeIsFilled() {
        if !otherCurrencyView.isHidden, let assetCode = otherCurrencyTextField.text, !assetCode.isMandatoryValid() {
            setValidationError(view: otherCurrencyErrorView, label: otherCurrencyErrorLabel, errorMessage: .Mandatory)
        }
    }
    
    private func validateAssetCode() {
        if let assetCode = otherCurrencyTextField.text {
            if !assetCode.isAssetCodeValid() {
                setValidationError(view: otherCurrencyErrorView, label: otherCurrencyErrorLabel, errorMessage: .InvalidAssetCode)
            } else {
                resetOtherCurrencyValidationError()
            }
        }
    }
    
    private func validateAddress() {
        if let address = addressTextField.text {
            if !address.isMandatoryValid() {
                setValidationError(view: addressErrorView, label: addressErrorLabel, errorMessage: .Mandatory)
                return
            }
            
            if address.isFederationAddress() {
                return
            }
            
            if !address.isBase64Valid() || !address.isPublicKey(){
                setValidationError(view: addressErrorView, label: addressErrorLabel, errorMessage: .InvalidAddress)
            }
        }
    }
    
    private func validateAmount() {
        if let amountToValidate = self.amountTextField.text, availableAmount == nil {
            if !amountToValidate.isMandatoryValid() {
                setValidationError(view: amountErrorView, label: amountErrorLabel, errorMessage: .Mandatory)
                return
            }
            
            validate(amount: amountToValidate)
        } else if let amountToValidate = availableAmount {
            validate(amount: String(amountToValidate))
        }
    }
    
    private func validate(amount: String) {
        if !amount.isNumeric() {
            setValidationError(view: amountErrorView, label: amountErrorLabel, errorMessage: .InvalidAmount)
            return
        }
        
        if let balance: String = (wallet as! FundedWallet).balances.first(where: { (balance) -> Bool in
            if selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                return balance.displayCode == selectedCurrency
            }
            
            return balance.displayCode == selectedCurrency && balance.assetIssuer == issuerTextField.text})?.balance {
            
            var balanceToValidate = balance
            
            if selectedCurrency == NativeCurrencyNames.xlm.rawValue {
                if let balance = CoinUnit(balance) {
                    balanceToValidate = String(balance.availableAmount(forWallet: wallet))
                }
            }
            
            if !amount.isAmountValid(forBalance: balanceToValidate) {
                amountErrorView.isHidden = false
                amountErrorLabel.text = "Insufficient \(selectedCurrency) available"
                isInputDataValid = false
            }
        }
    }
    
    private func validateMemo() {
        if let memoText = self.memoInputTextField.text {
            if memoText.isEmpty == true {
                return
            }
            
            switch selectedMemoType.rawValue {
            case MemoTypeValues.MEMO_TEXT.rawValue:
                let memoTextValidationResult: MemoTextValidationResult = memoText.isMemoTextValid(limitNrOfBytes: MaximumLengthInBytesForMemoText)
                
                if memoTextValidationResult == MemoTextValidationResult.InvalidEncoding {
                    setValidationError(view: memoInputErrorView, label: memoInputErrorLabel, errorMessage: .InvalidMemo)
                    return
                }
                
                if memoTextValidationResult == MemoTextValidationResult.InvalidLength {
                    setValidationError(view: memoInputErrorView, label: memoInputErrorLabel, errorMessage: .MemoLength)
                    return
                }
                
            case MemoTypeValues.MEMO_ID.rawValue:
                if !memoText.isMemoIDValid() {
                    setValidationError(view: memoInputErrorView, label: memoInputErrorLabel, errorMessage: .InvalidMemo)
                }
                
            case MemoTypeValues.MEMO_HASH.rawValue:
                if !memoText.isMemoHashValid() {
                    setValidationError(view: memoInputErrorView, label: memoInputErrorLabel, errorMessage: .InvalidMemo)
                }
                
            case MemoTypeValues.MEMO_RETURN.rawValue:
                if !memoText.isMemoReturnValid() {
                    setValidationError(view: memoInputErrorView, label: memoInputErrorLabel, errorMessage: .InvalidMemo)
                }
                
            default:
                break
            }
        }
    }
    
    private func validateSignersSeed() {
        if let currentSeed = signerSeedTextField.text {
            if !currentSeed.isMandatoryValid() {
                setValidationError(view: seedErrorView, label: seedErrorLabel, errorMessage: .Mandatory)
                return
            }
            
            if let signerKeyPair = try? KeyPair(secretSeed: currentSeed) {
                if signerKeyPair.accountId != signerTextField.text {
                    setValidationError(view: seedErrorView, label: seedErrorLabel, errorMessage: .InvalidSignerSeed)
                }
            } else {
                setValidationError(view: seedErrorView, label: seedErrorLabel, errorMessage: .InvalidSignerSeed)
            }
        }
    }
    
    private func validatePassword(biometricAuth: Bool = false) {
        if biometricAuth {
            return
        }
        
        if passwordStackView.isHidden {
            validateSignersSeed()
            return
        }
        
        if let currentPassword = passwordTextField.text {
            if !currentPassword.isMandatoryValid() {
                setValidationError(view: passwordErrorView, label: passwordErrorLabel, errorMessage: .Mandatory)
                return
            }
            
            if !isInputDataValid {
                return
            }
        }
    }
    
    private func checkForRecipientAccount() {
        if !isInputDataValid || isSendAnywayRequired {
            if isSendAnywayRequired {
                isInputDataValid = true
            }

            return
        }
    }
    
    private func validateInsertedData(biometricAuth: Bool = false) -> Bool {
        validateAddress()
        validateAssetCodeIsFilled()
        validateAmount()
        validateMemo()
        validatePassword(biometricAuth: biometricAuth)
        checkForTransactionFeeAvailability()
        checkForRecipientAccount()
        
        return isInputDataValid
    }
    
    func setQR(value: String) {
        // QR Valid Structure:
        // Currency: XML
        // Issuer: KAJSHDJAS.../native
        // Address: KJSAHDJKASH...
        // Amount: 500
        // MemoType: none/text/id/hash/return
        // Memo: none/value
        // Password: asdfdasjkd
        
        // Example: XML native me@me.me 500 none none 1234
        
        let qrResultArray = value.components(separatedBy: QRCodeSeparationString)
        
        if qrResultArray.count != 7 {
            scanViewController.view.removeFromSuperview()
            scanViewController = nil
            return
        }
        
        currentCurrencyTextField.text = nil
        currentCurrencyTextField.insertText(qrResultArray[0])
        issuerTextField.text = qrResultArray[1] != QRCodeNativeCurrencyIssuer ? qrResultArray[1] : nil
        addressTextField.text = qrResultArray[2]
        amountTextField.text = qrResultArray[3]
        
        switch qrResultArray[4] {
        case MemoTypeAsString.TEXT:
            memoTypeTextField.text = MemoTypeValues.MEMO_TEXT.rawValue
        case MemoTypeAsString.ID:
            memoTypeTextField.text = MemoTypeValues.MEMO_ID.rawValue
        case MemoTypeAsString.HASH:
            memoTypeTextField.text = MemoTypeValues.MEMO_HASH.rawValue
        case MemoTypeAsString.RETURN:
            memoTypeTextField.text = MemoTypeValues.MEMO_RETURN.rawValue
        default:
            break
        }
        
        if qrResultArray[5] != MemoTypeAsString.NONE {
            memoInputTextField.text = qrResultArray[5]
        }
        
        passwordTextField.text = qrResultArray[6]
        scanViewController.view.removeFromSuperview()
        scanViewController = nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPickerView {
            return availableCurrencies.count
        } else if pickerView == memoTypePickerView {
            return memoTypes.count
        } else if pickerView == issuerPickerView {
            return (wallet as! FundedWallet).issuersFor(assetCode: selectedCurrency).count
        } else if pickerView == signerPickerView {
            return availableSigners.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPickerView {
            if availableCurrencies[row] == NativeCurrencyNames.xlm.rawValue {
                return NativeCurrencyNames.stellarLumens.rawValue
            }
            
            return availableCurrencies[row]
        } else if pickerView == memoTypePickerView {
            return memoTypes[row].rawValue
        } else if pickerView == issuerPickerView {
            return (wallet as! FundedWallet).issuersFor(assetCode: selectedCurrency)[row]
        } else if pickerView == signerPickerView {
            return availableSigners[row].publicKey
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectAsset(pickerView: pickerView, row: row)
    }
    
    @IBAction func didTapScan(_ sender: Any) {
        showQRScanner()
    }
    
    private func selectAsset(pickerView: UIPickerView, row: Int) {
        if pickerView == currencyPickerView {
            if availableCurrencies[row] == OtherCurrencyText {
                setupForOtherCurrency()
                return
            }
        
        setupForSelectedCurrency()
        selectedCurrency = availableCurrencies[row]
        return
        } else if pickerView == memoTypePickerView {
            selectedMemoType = memoTypes[row]
            return
        } else if pickerView == issuerPickerView {
            issuerTextField.text = (wallet as! FundedWallet).issuersFor(assetCode: selectedCurrency)[row]
            return
        } else if pickerView == signerPickerView {
            signerTextField.text = availableSigners[row].publicKey
        }
    }
    
    private func resetSendButtonToNormal() {
        sendButton.setTitle(isSendAnywayRequired ? SendButtonTitles.sendAnyway.rawValue : getSendButtonDefaultTitle(), for: UIControlState.normal)
        sendButton.isEnabled = true
    }
    
    private func setupNavigationItem() {
        navigationItem.titleLabel.text = "Send"
        navigationItem.titleLabel.textColor = Stylesheet.color(.white)
        navigationItem.titleLabel.font = R.font.encodeSansSemiBold(size: 15)
        
        let scanQrButton = Material.IconButton()
        scanQrButton.image = R.image.qr_placeholder()?.crop(toWidth: 15, toHeight: 15)?.tint(with: Stylesheet.color(.white))
        scanQrButton.addTarget(self, action: #selector(didTapScan(_:)), for: .touchUpInside)
        navigationItem.rightViews = [scanQrButton]
    }
    
    private func hideBiometricAuthButton() {
        biometricAuthView.isHidden = true
    }
}
