//
//  TxAllowTrustOperationResponse.swift
//  Lumenshine
//
//  Created by Elekes Istvan on 14/11/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation

class TxAllowTrustOperationResponse: TxOperationResponse {
    
    /// Trustor account.
    public let trustor:String
    
    /// Trustee account.
    public let trustee:String
    
    /// Asset type (native / alphanum4 / alphanum12)
    public let assetType:String
    
    /// Asset code.
    public let assetCode:String?
    
    /// Asset issuer.
    public let assetIssuer:String?
    
    /// true when allowing trust, false when revoking trust.
    public let authorize:Bool
    
    /// The limit for the asset.
    private enum CodingKeys: String, CodingKey {
        case trustor
        case trustee
        case assetType = "asset_type"
        case assetCode = "asset_code"
        case assetIssuer = "asset_issuer"
        case authorize
    }
    
    /**
     Initializer - creates a new instance by decoding from the given decoder.
     
     - Parameter decoder: The decoder containing the data
     */
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trustor = try values.decode(String.self, forKey: .trustor)
        trustee = try values.decode(String.self, forKey: .trustee)
        assetType = try values.decode(String.self, forKey: .assetType)
        assetCode = try values.decodeIfPresent(String.self, forKey: .assetCode)
        assetIssuer = try values.decodeIfPresent(String.self, forKey: .assetIssuer)
        authorize = try values.decode(Bool.self, forKey: .authorize)
        
        try super.init(from: decoder)
    }
}