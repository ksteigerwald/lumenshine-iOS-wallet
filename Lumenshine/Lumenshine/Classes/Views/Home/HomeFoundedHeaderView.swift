//
//  HomeFoundedHeaderView.swift
//  Lumenshine
//
//  Created by Razvan Chelemen on 13/06/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import UIKit
import Material

class HomeFoundedHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foundAccountButton: UILabel!
    @IBOutlet weak var sendButton: IconButton!
    @IBOutlet weak var receiveButton: IconButton!
    @IBOutlet weak var moreButton: IconButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        titleLabel.text = R.string.localizable.homeScreenTitle()
        titleLabel.font = UIFont.systemFont(ofSize: 25.0)
        titleLabel.textColor = UIColor.white
        
        sendButton.iconLabel.text = R.string.localizable.send()
        sendButton.iconImageView.image = MaterialIcon.send.size36pt
        receiveButton.iconLabel.text = R.string.localizable.receive()
        receiveButton.iconImageView.image = MaterialIcon.received.size36pt
        moreButton.iconLabel.text = R.string.localizable.more()
        moreButton.iconImageView.image = MaterialIcon.moreHorizontal.size36pt
    }
    
}