//
//  EventsService.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import Alamofire

class EventsService : WoopNetworkService, EventsListVMDataProvider, EventDetailVMDataProvider, CheckInVMDataProvider {
    
    let eventsPath = "/events"
    let checkInPath = "/checkin"
    
    func fetchEvents(completion: @escaping (WoopRequestErrorModel?, FetchEventsResponse?) -> Void) {
        super.requestJson("\(apiURL + eventsPath)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { (error, data) in
            if let err = error {
                completion(err, nil)
                return
            }
            if let json = data?.jsonValue {
                let model = FetchEventsResponse(json: json)
                completion(nil, model)
                return
            }
        }
    }
    
    func fetchEventDetails(eventID: String, completion: @escaping (WoopRequestErrorModel?, FetchEventDetailsResponse?) -> Void) {
        super.requestJson("\(apiURL + eventsPath)/\(eventID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { (error, data) in
            if let err = error {
                completion(err, nil)
                return
            }
            if let json = data?.jsonValue {
                let model = FetchEventDetailsResponse(json: json)
                completion(nil, model)
                return
            }
        }
    }
    
    func sendCheckIn(eventID: String, name: String, email: String, completion: @escaping (WoopRequestErrorModel?) -> Void) {
        let params = SendEventRequest(currEventId: eventID, currName: name, currEmail: email)
        super.requestJson("\(apiURL + checkInPath)", method: .post, parameters: params.toParameters(), encoding: JSONEncoding.default, headers: nil) { (error, data) in
            completion(error)
        }
    }
}


