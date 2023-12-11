//
//  FiltersView.swift
//  financecontrol
//
//  Created by PinkXaciD on R 5/11/21.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject
    private var cdm: CoreDataModel
    @Environment(\.dismiss)
    private var dismiss
    @AppStorage("color")
    private var tint: String = "Orange"
    
    @Binding
    var firstFilterDate: Date
    @Binding
    var secondFilterDate: Date
    @Binding
    var categories: [CategoryEntity]
    @Binding
    var excludeCategories: Bool
    @Binding
    var applyFilters: Bool
    
    @State
    private var showCategoriesPicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                dateSection
                    .datePickerStyle(.compact)
                
                categoriesSection
                
                clearButton
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbar
                
                trailingToolbar
            }
        }
        .accentColor(colorIdentifier(color: tint))
    }
    
    private var dateSection: some View {
        Section(header: dateSectionHeader) {
            firstDatePicker
            
            secondDatePicker
        }
    }
    
    private var dateSectionHeader: some View {
        Text("Date")
    }
    
    private var firstDatePicker: some View {
        let firstDate: Date = cdm.savedSpendings.last?.wrappedDate ?? .init(timeIntervalSinceReferenceDate: 0)
        
        return DatePicker("From", selection: $firstFilterDate, in: firstDate...secondFilterDate, displayedComponents: .date)
    }
    
    private var secondDatePicker: some View {
        DatePicker("To", selection: $secondFilterDate, in: firstFilterDate...Date.now, displayedComponents: .date)
    }
    
    private var categoriesSection: some View {
        Group {
            Section(header: categoriesSectionHeader) {
                Button {
                    toggleCategoriesPicker()
                } label: {
                    categoriesPickerLabel
                }
                
                if showCategoriesPicker {
                    Toggle("Exclude", isOn: $excludeCategories)
                }
            }
            
            if showCategoriesPicker {
                Section {
                    ForEach(cdm.savedCategories) { category in
                        Button {
                            categoryButtonAction(category)
                        } label: {
                            categoryRowLabel(category)
                        }
                    }
                }
            }
        }
    }
    
    private var categoriesSectionHeader: some View {
        Text("Categories")
    }
    
    private var categoriesPickerLabel: some View {
        HStack {
            Text("Categories")
            
            Spacer()
            
            Text("\(categories.count) selected")
                .foregroundColor(.secondary)
        }
    }
    
    private var clearButton: some View {
        Button("Clear", role: .destructive) {
            applyFilters = false
            dismiss()
            DispatchQueue.main.async {
                firstFilterDate = cdm.savedSpendings.last?.wrappedDate ?? .init(timeIntervalSinceReferenceDate: 0)
                secondFilterDate = .now
                categories = []
                excludeCategories = false
            }
        }
    }
    
    private var leadingToolbar: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close") {
                dismiss()
            }
        }
    }
    
    private var trailingToolbar: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Apply") {
                applyFilters = true
                dismiss()
            }
            .font(.body.bold())
        }
    }
}
    
extension FiltersView {
    private func toggleCategoriesPicker() {
        withAnimation {
            showCategoriesPicker.toggle()
        }
    }
    
    private func categoryButtonAction(_ category: CategoryEntity) {
        if categories.contains(category) {
            let index: Int = categories.firstIndex(of: category) ?? 0
            categories.remove(at: index)
        } else {
            categories.append(category)
        }
    }
    
    private func categoryRowLabel(_ category: CategoryEntity) -> some View {
        return HStack {
            Text(category.name ?? "Error")
                .foregroundColor(.primary)
            
            Spacer()
            
            if categories.contains(category) {
                Image(systemName: "checkmark")
                    .font(.body.bold())
            }
        }
    }
}
