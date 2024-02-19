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
        Section {
            NavigationLink {
                FiltersCategoriesView(categories: $categories, applyFilters: $applyFilters, cdm: cdm)
            } label: {
                categoriesPickerLabel
            }
        } header: {
            Text("Categories")
        }
    }
    
    private var categoriesPickerLabel: some View {
        HStack(spacing: 5) {
            Text("Categories")
            
            Spacer()
            
            Text("\(categories.count) selected")
                .foregroundColor(.secondary)
        }
    }
    
    private var clearButton: some View {
        Button("Clear", role: .destructive) {
            clearFilters()
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
    
    private func clearFilters() {
        withAnimation(.linear(duration: 0.1)) {
            applyFilters = false
            categories = []
        }
        firstFilterDate = .now.getFirstDayOfMonth()
        secondFilterDate = .now
    }
}

struct FiltersCategoriesView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @Binding 
    var categories: [CategoryEntity]
    @Binding
    var applyFilters: Bool
    
    let listData: [CategoryEntity]
    
    var body: some View {
        List {
            Section {
                ForEach(listData) { category in
                    Button {
                        categoryButtonAction(category)
                    } label: {
                        categoryRowLabel(category)
                    }
                }
            }
            
            Section {
                Button("Clear selection", role: .destructive) {
                    categories.removeAll()
                }
                .disabled(categories.isEmpty)
                .animation(.default.speed(2), value: categories)
            }
        }
        .navigationTitle("Filter by Categories")
        .toolbar {
            trailingToolbar
        }
    }
    
    private var trailingToolbar: ToolbarItem<Void, some View> {
        ToolbarItem {
            Button("Save") {
                dismiss()
            }
            .font(.body.bold())
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
            Image(systemName: "circle.fill")
                .foregroundColor(Color[category.color ?? ""])
                .font(.body)
                
            Text(category.name ?? "Error")
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.body.bold())
                .opacity(categories.contains(category) ? 1 : 0)
                .animation(.default.speed(3), value: categories)
        }
    }
    
    init(categories: Binding<[CategoryEntity]>, applyFilters: Binding<Bool>, cdm: CoreDataModel) {
        self._categories = categories
        self._applyFilters = applyFilters
        self.listData = (cdm.savedCategories + cdm.shadowedCategories).sorted { $0.name ?? "" < $1.name ?? "" }
    }
}
