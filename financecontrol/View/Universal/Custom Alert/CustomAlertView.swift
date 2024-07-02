//
//  CustomAlertView.swift
//  financecontrol
//
//  Created by PinkXaciD on R 5/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    var data: CustomAlertData
    @StateObject private var viewModel: CustomAlertViewModel
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.regular)
                .shadow(radius: 5)
            
            HStack {
                Image(systemName: data.systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(animate ? 1 : 0.1)
                    .foregroundColor(data.type.color)
                    .padding()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                        
                        if let description = data.description {
                            Text(description)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .padding(.horizontal)
        .onAppear {
            withAnimation(.bouncy) {
                self.animate = true
            }
        }
        .onTapGesture {
            withAnimation(.bouncy) {
                CustomAlertManager.shared.removeAlert(data.id)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.predictedEndTranslation.height < -5 {
                        withAnimation(.bouncy) {
                            CustomAlertManager.shared.removeAlert(data.id)
                        }
                    }
                }
        )
        .transition(.opacity.combined(with: .scale).combined(with: .move(edge: .top)))
    }
    
    init(data: CustomAlertData) {
        self.data = data
        self._viewModel = StateObject(wrappedValue: .init(id: data.id, haptic: data.type.haptic))
    }
}

#if DEBUG
#Preview {
    VStack {
        CustomAlertView(data: .init(type: .error, title: "Error", description: "Description.", systemImage: "xmark.circle"))
        CustomAlertView(data: .init(type: .warning, title: "Warning", description: "Description.", systemImage: "exclamationmark.circle"))
        CustomAlertView(data: .init(type: .success, title: "Success", description: "Description.", systemImage: "checkmark.circle"))
        CustomAlertView(data: .init(type: .info, title: "Info", description: "Description.", systemImage: "questionmark.circle"))
    }
}
#endif
