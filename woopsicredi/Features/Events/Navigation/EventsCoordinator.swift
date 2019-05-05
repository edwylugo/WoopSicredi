//
//  EventsCoordinator.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import UIKit


class EventsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = EventsListVC()
        let provider = EventsService()
        let model = EventsListVM(provider: provider)
        vc.coordinator = self
        vc.delegate = self
        vc.model = model
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToEventDetails(eventID: String) {
        let vc = EventDetailVC()
        let provider = EventsService()
        let model = EventDetailVM(provider: provider,eventID: eventID)
        vc.model = model
        vc.coordinator = self
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToCheckIn(eventID: String) {
        let vc = CheckInVC()
        let provider = EventsService()
        let model = CheckInVM(provider: provider,eventID: eventID)
        vc.model = model
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}

extension EventsCoordinator : EventsListCoordinatorDelegate {
    func didSelectEvent(eventID: String) {
        goToEventDetails(eventID: eventID)
    }
}

extension EventsCoordinator : EventDetailsCoordinatorDelegate {
    func didAskForCheckIn(eventID: String) {
        goToCheckIn(eventID: eventID)
    }
}

