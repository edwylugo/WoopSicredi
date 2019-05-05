//
//  FetchEventDetailsResponse.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import SwiftyJSON

struct FetchEventDetailsResponse : WoopDataModel {
    var eventData: EventData? = nil
    
    init(json: JSON) {
        eventData = EventData(json: json)
    }
}
