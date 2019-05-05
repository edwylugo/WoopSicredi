//
//  DataResponseExtension.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import Alamofire
import SwiftyJSON

extension DataResponse {
    
    var jsonValue: JSON {
        return JSON(result.value)
    }
}

