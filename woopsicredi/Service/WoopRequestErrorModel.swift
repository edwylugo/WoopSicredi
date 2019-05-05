//
//  WoopRequestErrorModel.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import Alamofire
import SwiftyJSON

class WoopRequestErrorModel {
    var statusCode: Int = 500
    var error: String = ""
    var errorDescription: String = "Não foi possível efetuar a operação. Por favor, tente mais tarde."
    var originalResponse: DataResponse<Any>? = nil
    
    // Didn't knew exactly how the model should be because we are working with a mock server, consider it the error contract.
    init(response: DataResponse<Any>? = nil) {
        if let res = response {
            let json = res.jsonValue
            self.statusCode = res.response?.statusCode ?? self.statusCode
            self.error = json["error"].string ?? self.error
            self.errorDescription = json["error_description"].string ?? self.errorDescription
            self.originalResponse = res
        }
    }
}
