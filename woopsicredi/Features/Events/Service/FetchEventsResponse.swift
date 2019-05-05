//
//  FetchEventsResponse.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import SwiftyJSON

struct FetchEventsResponse : WoopDataModel {
    var events: [EventData]? = nil
    
    init(json: JSON) {
        var eventsArray = [EventData]()
        for (_, object) in json {
            eventsArray.append(EventData(json: object))
        }
        events = eventsArray
    }
}

struct EventData : WoopDataModel {
    var id: String? = nil
    var title: String? = nil
    var price: Double? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    var imageURL: String? = nil
    var description: String? = nil
    var date: Int? = nil
    var people: [PeopleData]? = nil
    var coupons: [CouponData]? = nil
    
    init(json: JSON) {
        id =  json["id"].string
        title =  json["title"].string
        price =  json["price"].double
        latitude =  json["latitude"].string
        longitude =  json["longitude"].string
        imageURL = json["image"].string
        description =  json["description"].string
        date = json["date"].int
        
        var peopleArray = [PeopleData]()
        if let pArray = json["people"].array {
            pArray.forEach { (json) in
                peopleArray.append(PeopleData(json: json))
            }
            people = peopleArray
        }
        
        var couponsArray = [CouponData]()
        if let cArray = json["cupons"].array {
            cArray.forEach { (json) in
                couponsArray.append(CouponData(json: json))
            }
            coupons = couponsArray
        }
    }
}

struct PeopleData : WoopDataModel {
    var id: String? = nil
    var eventId: String? = nil
    var name: String? = nil
    var pictureURL: String? = nil
    
    init(json: JSON) {
        id =  json["id"].string
        eventId =  json["eventId"].string
        name =  json["name"].string
        pictureURL =  json["picture"].string
    }
}

struct CouponData : WoopDataModel {
    var id: String? = nil
    var eventId: String? = nil
    var discount: Int? = nil
    
    init(json: JSON) {
        id =  json["id"].string
        eventId =  json["eventId"].string
        discount =  json["discount"].int
    }
}
