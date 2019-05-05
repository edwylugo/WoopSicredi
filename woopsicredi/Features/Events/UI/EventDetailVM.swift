//
//  EventDetailVM.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation

protocol EventDetailVMDataProvider {
    func fetchEventDetails(eventID: String, completion: @escaping (_ error: WoopRequestErrorModel?, _ model: FetchEventDetailsResponse?) -> Void)
}

class EventDetailVM {
    
    let title = "Detalhes"
    let tryAgainTitle = "Tentar novamente"
    let notImplementedButtonTitle = "OK"
    let errorIconName = "error-icon"
    let defaultTitle = "Falha na requisição"
    let peopleLabelText = "Pessoas"
    let voucherLabelText = "Cupons"
    let checkInTitle = "Check In"
    
    var provider: EventDetailVMDataProvider
    var fetchEventDetails: FetchEventDetailsResponse? = nil
    var currentEventID: String
    
    init(provider: EventDetailVMDataProvider, eventID: String) {
        self.provider = provider
        self.currentEventID = eventID
    }
    
    func fetchEventDetails(completion: @escaping (_ error: WoopRequestErrorModel?, _ model: FetchEventDetailsResponse?) -> Void) {
        provider.fetchEventDetails(eventID: currentEventID) { [weak self] (error, model) in
            guard let weakSelf = self else { return }
            weakSelf.fetchEventDetails = model
            completion(error,model)
        }
    }
}

