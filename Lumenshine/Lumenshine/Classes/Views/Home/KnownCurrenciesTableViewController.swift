//
//  KnownCurrenciesTableViewController.swift
//  Lumenshine
//
//  Created by Soneso on 27/08/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension KnownCurrency {
    static var expandedCurrency: String = ""
    
    private var getID: String {
        get {
            return self.assetCode + self.issuerPublicKey
        }
    }
    
    var isExpanded:Bool {
        get {
            return KnownCurrency.expandedCurrency == self.getID
        }
        set(newValue) {
            if newValue {
            KnownCurrency.expandedCurrency = self.getID
            } else {
                KnownCurrency.expandedCurrency = ""
            }
        }
    }
}

class KnownCurrenciesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var headerViewController: LoadTransactionsHistoryViewController!
    private let CellIdentifier = "KnownCurrenciesTableViewCell"
    private var itemsSource: [KnownCurrency] = []
    private var knownCurrenciesManager = KnownCurrenciesManager()
    private var currentExpandedRowIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setTableViewHeader()
        getKnownCurrencies()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        KnownCurrency.expandedCurrency = ""
    }
    
    private func setTableViewHeader() {
        headerViewController = LoadTransactionsHistoryViewController(nibName: "LoadTransactionsHistoryViewController", bundle: Bundle.main, initialState: .showLoading)
        tableView.tableHeaderView = headerViewController.view
    }
    
    private func getKnownCurrencies() {
        knownCurrenciesManager.getKnownCurrencies { (response) -> (Void) in
            switch response {
            case .success(response: let knownCurrencies):
                self.itemsSource = knownCurrencies
                self.tableView.tableHeaderView = nil
                self.tableView.reloadData()
            case .failure(error: let error):
                print("Error: \(error)")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KnownCurrenciesTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! KnownCurrenciesTableViewCell
        
        let knownCurrency = itemsSource[indexPath.section]
        
        if let currencyName = knownCurrency.name, let currencyAssetCode = knownCurrency.assetCode {
            cell.assetCodeLabel.text = "\(currencyName) (\(currencyAssetCode))"
        }

        cell.authorizationLabel.isHidden = knownCurrency.isAuthorized
        
        if let issuer = knownCurrency.issuerPublicKey {
            cell.issuerPublicKeyLabel.text = "Issuer public key: \n\(issuer)"
        }
        
        if knownCurrency.isExpanded {
            cell.expand()
        } else {
            cell.collapse()
        }
        
        if BiometricHelper.isBiometricAuthEnabled {
            cell.passwordTextField.isHidden = true
        }
                
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsSource[indexPath.section].isExpanded = !itemsSource[indexPath.section].isExpanded
        
        var rowsThatNeedReload = [indexPath]
        
        if currentExpandedRowIndexPath != indexPath, let previousExpandedRow = currentExpandedRowIndexPath {
            rowsThatNeedReload.append(previousExpandedRow)
        }
        
        currentExpandedRowIndexPath = indexPath
        tableView.reloadRows(at: rowsThatNeedReload, with: UITableViewRowAnimation.fade)
    }
}
