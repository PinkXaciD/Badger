//
//  FiltersCurrenciesView.swift
//  Squirrel
//
//  Created by PinkXaciD on R 6/06/12.
//

import SwiftUI

struct FiltersCurrenciesView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @EnvironmentObject
    private var fvm: FiltersViewModel
    @EnvironmentObject
    private var cdm: CoreDataModel
    
    var body: some View {
        List {
            ForEach(cdm.usedCurrencies.sorted(by: <)) { currency in
                Button {
                    rowAction(currency.code)
                } label: {
                    rowLabel(currency)
                }
            }
            
            if !cdm.usedCurrencies.isEmpty {
                Section {
                    Button("Clear selection", role: .destructive) {
                        fvm.currencies = []
                    }
                    .disabled(fvm.currencies.isEmpty)
                    .animation(.default.speed(3), value: fvm.currencies)
                }
            }
        }
        .navigationTitle("Currencies")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            trailingToolbar
        }
        .overlay {
            if cdm.usedCurrencies.isEmpty {
                CustomContentUnavailableView("No Expenses", imageName: "list.bullet", description: "You can add expenses from home screen.")
            }
        }
    }
    
    private var trailingToolbar: ToolbarItem<Void, some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .bold()
            }

        }
    }
    
    private func rowLabel(_ currency: Currency) -> some View {
        HStack {
            Text(currency.name ?? currency.code)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.body.bold())
                .opacity(fvm.currencies.contains(currency.code) ? 1 : 0)
                .animation(.default.speed(3), value: fvm.currencies)
        }
    }
    
    private func rowAction(_ code: String) {
        if let index = fvm.currencies.firstIndex(of: code) {
            fvm.currencies.remove(at: index)
            return
        }
        
        fvm.currencies.append(code)
    }
}
