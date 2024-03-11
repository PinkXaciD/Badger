//
//  FiltersViewModel.swift
//  Squirrel
//
//  Created by PinkXaciD on R 6/02/27.
//

import Combine
import SwiftUI
#if DEBUG
import OSLog
#endif

final class FiltersViewModel: ViewModel {
    @Published
    var startFilterDate: Date
    @Published
    var endFilterDate: Date
    @Published
    var filterCategories: [UUID]
    @Published
    var applyFilters: Bool
    @Published
    var updateList: Bool
    @Published
    var search: String
    let pcvm: PieChartViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(pcvm: PieChartViewModel) {
        self.applyFilters = false
        self.startFilterDate = .now.getFirstDayOfMonth()
        self.endFilterDate = .now
        self.filterCategories = []
        self.updateList = false
        self.search = ""
        self.pcvm = pcvm
        
//        subscribeToSelection()
        
        #if DEBUG
        let logger = Logger(subsystem: Vars.appIdentifier, category: #fileID)
        logger.debug("ViewModel initialized")
        #endif
    }
    
    deinit {
        #if DEBUG
        let logger = Logger(subsystem: Vars.appIdentifier, category: #fileID)
        logger.debug("ViewModel deinitialized")
        #endif
    }
    
    func clearFilters() {
        self.applyFilters = false
        self.startFilterDate = .now.getFirstDayOfMonth()
        self.endFilterDate = .now
        self.filterCategories = []
        self.updateList = true
        self.pcvm.isScrollDisabled = false
    }
    
    private func subscribeToSelection() {
        pcvm.$selection
//            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] value in
                guard let self else { return }
                
                if value == 0 {
                    if self.filterCategories.isEmpty {
                        withAnimation {
                            self.applyFilters = false
                            self.updateList = true
                        }
                    }
                    
                    withAnimation {
                        self.startFilterDate = .now.getFirstDayOfMonth()
                        self.endFilterDate = .now
                    }
                } else {
                    withAnimation {
                        self.startFilterDate = .now.getFirstDayOfMonth(-value)
                        self.endFilterDate = .now.getFirstDayOfMonth(-value + 1)
                        self.applyFilters = true
                        self.updateList = true
                    }
                }
                #if DEBUG
                let logger = Logger(subsystem: Vars.appIdentifier, category: #fileID)
                logger.debug("\(#function) worked")
                #endif
                HapticManager.shared.impact(.soft)
            }
            .store(in: &cancellables)
    }
    
    func listUpdated() {
        self.updateList = false
    }
}

