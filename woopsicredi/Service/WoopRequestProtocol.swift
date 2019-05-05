//
//  WoopRequestProtocol.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation

protocol WoopRequest {
    func toParameters() -> [String:Any]
}
