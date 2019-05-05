//
//  CheckInVM.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation

protocol CheckInVMDataProvider {
    func sendCheckIn(eventID: String, name: String, email: String ,completion: @escaping (_ error: WoopRequestErrorModel?) -> Void)
}

class CheckInVM {
    
    let title = "Check In"
    let nameLabelText = "Nome"
    let nameLabelErrorText = "Nome Inválido"
    let emailLabelText = "Email"
    let emailLabelErrorText = "Email Inválido"
    let checkInButtonTitle = "Check In"
    let errorIconName = "error-icon"
    let successIconName = "success-icon"
    let alertErrorTitle = "Falha na requisição"
    let alertSuccessTitle = "Check In Efetuado"
    let alertSuccessDesc = "Check In efetuado com sucesso, clique em ok para voltar."
    let alertSuccessButtonTitle = "OK"
    let alertcheckInTryAgainButtonTitle = "Tenter novamente"
    let emptyString = ""
    
    var provider: CheckInVMDataProvider
    var currentEventID: String
    
    init(provider: CheckInVMDataProvider, eventID: String) {
        self.provider = provider
        self.currentEventID = eventID
    }
    
    func sendCheckIn(name: String, email: String, completion: @escaping (_ error: WoopRequestErrorModel?) -> Void) {
        provider.sendCheckIn(eventID: currentEventID, name: name, email: email) { (error) in
            completion(error)
        }
    }
}
