//
//  LanguageResponse.swift
//  Lumenshine
//
//  Created by Soneso GmbH on 12/12/2018.
//  Munich, Germany
//  web: https://soneso.com
//  email: hi@soneso.com
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation

public class LanguageResponse: Decodable, PersonalDataProtocol {
    
    let name: String
    let code: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "lang_name"
        case code = "lang_code"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
    }
}
