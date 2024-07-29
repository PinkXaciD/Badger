//
//  WeeklySpendingsTodaySumView.swift
//  SquirrelWidgetExtension
//
//  Created by PinkXaciD on R 6/07/26.
//

import SwiftUI

struct WeeklySpendingsMediumTodaySumView: View {
    let sum: Double
    let avg: Double
    let currency: String
    
    var numberFormat: FloatingPointFormatStyle<Double> {
        if sum > 99999 {
            return .number.notation(.compactName)
        }
        
        return .number.precision(.fractionLength(0...2))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Today:")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 1)
                    .privacySensitive()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(currency)
                        .font(.system(.title3, design: .rounded).bold())
                    
                    Text(sum.formatted(numberFormat))
                        .font(.system(.title, design: .rounded).bold())
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                }
                .privacySensitive()
                
                Divider()
                    .padding(.vertical, 5)
                
                Text("Average:")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .privacySensitive()
                
                VStack(alignment: .leading) {
                    Text(avg.formatted(.currency(code: currency).precision(.fractionLength(0))))
                        .font(.system(.body, design: .rounded).bold())
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                }
                .privacySensitive()
            }
            
            Spacer()
        }
// TODO: Add spending button
//        .overlay(alignment: .topTrailing) {
//            Image(systemName: "plus.circle.fill")
//                .foregroundColor(.accentColor)
//                .font(.title2)
//        }
    }
}

struct WeeklySpendingsSmallTodaySumView: View {
    let currency: String
    let sum: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today:")
                .font(.footnote)
                .foregroundColor(.secondary)
                .privacySensitive()
            
            Text(sum.formatted(.currency(code: currency).precision(.fractionLength(0))))
                .font(.system(.title3, design: .rounded).bold())
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .privacySensitive()
        }
    }
}

