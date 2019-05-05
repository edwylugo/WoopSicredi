//
//  EventsListVM.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation

protocol EventsListVMDataProvider {
    func fetchEvents(completion: @escaping (_ error: WoopRequestErrorModel?, _ model: FetchEventsResponse?) -> Void)
}

class EventsListVM {
    
    let title = "Eventos"
    let cellReuseIdendifier = "cell"
    let dateFormatValue = "dd/MM/yyyy - HH:mm"
    let tryAgainTitle = "Tentar novamente"
    let errorIconName = "error-icon"
    let defaultTitle = "Falha na requisição"
    let defaultErrorMessage = "Erro desconhecido"
    
    var entries = [EventsListTableViewCellModel]()
    var provider: EventsListVMDataProvider
    var fetchEventsResponse: FetchEventsResponse? = nil {
        didSet {
            if fetchEventsResponse != nil {
                setupEntries()
            }
        }
    }
    
    
    init(provider: EventsListVMDataProvider) {
        self.provider = provider
    }
    
    func fetchEvents(completion: @escaping (_ error: WoopRequestErrorModel?, _ model: FetchEventsResponse?) -> Void) {
        provider.fetchEvents { [weak self] (error, model) in
            guard let weakSelf = self else { return }
            weakSelf.fetchEventsResponse = model
            completion(error,model)
        }
    }
    
    func setupEntries() {
        entries = [EventsListTableViewCellModel]()
        guard let eventsArray = fetchEventsResponse?.events else { return }
        for entry in eventsArray {
            guard let desc = entry.title, let price = entry.price, let id = entry.id, let picURL = entry.imageURL, let date = entry.date else { return }
            let priceFormatted = "  \(Money.format(fromDouble: price, withPrefix: true, valueIfNull: "--"))    "
            // didn't knew about the time contract, just considered it seconds after 1970 (usually we should not do this conversions in the app, should come formatted from bff)
            let dateConverted = Date(timeIntervalSince1970: TimeInterval(date)).toFormat(dateFormatValue)
            entries.append(EventsListTableViewCellModel(currTitle: desc, currPrice: priceFormatted, currId: id, currPictureURL: picURL, currDate: dateConverted))
        }
    }
}
