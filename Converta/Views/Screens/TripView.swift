//
//  TripView.swift
//  Converta
//
//  Created by Ernest Dainals on 08/08/2023.
//

import SwiftUI

// MARK: Deprecated
struct TripView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    // Will be moved to ViewModel or CloudKit keyValueStore.
    @State private var defaultBaseCurrency: CurrencyCode? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Your Default Base Currency")
                        .customFont(size: 20, weight: .bold)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    Text("Default base currency is usually the currency used in your home country.")
                        .customFont(size: 15, weight: .medium)
                        .foregroundColor(.secondary)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                    
                    if defaultBaseCurrency != nil {
                        Button {
                            HapticManager.shared.impact(style: .soft)
                            // Show default base currency edit screen
                        } label: {
                            HStack {
                                Text(countryFlag(countryCode: String(defaultBaseCurrency?.rawValue.dropLast() ?? "US")))
                                    .customFont(size: 35, weight: .bold)
                                
                                HStack(spacing: 5) {
                                    let defaultBaseCurrencyName = viewModel.currentAPIResponse_Currencies?.data[defaultBaseCurrency?.rawValue ?? "USD"]??.name ?? "US Dollar"
                                    
                                    Text(defaultBaseCurrencyName)
                                        .customFont(size: 23, weight: .bold)
                                }.foregroundColor(.primary)
                            }
                            .alignView(to: .leading)
                            .padding()
                            .background(Material.ultraThin)
                            .cornerRadius(15)
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "pencil")
                                    .imageScale(.small)
                                    .foregroundColor(.brandWhite)
                                    .padding(5)
                                    .background { Circle().foregroundColor(.accentColor) }
                                    .padding(7)
                            }
                        }.scaleButtonStyle().padding(.horizontal)
                    } else {
                        Button {
                            HapticManager.shared.impact(style: .soft)
                            // Show default base currency create screen
                        } label: {
                            HStack {
                                Image(systemName: "house.and.flag.fill")
                                    .fontWeight(.semibold)
                                
                                Text("Set your default base currency")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .alignView(to: .leading)
                            .padding()
                            .background(Color.brandPurple3.gradient)
                            .cornerRadius(15)
                        }.scaleButtonStyle().padding(.horizontal)
                    }
                }
                
                VStack {
                    Divider().padding([.horizontal, .top])
                    
                    Text("Your Trips")
                        .customFont(size: 20, weight: .bold)
                        .alignView(to: .leading)
                        .padding(.horizontal)
                        .padding(.top, 3)
                    
                    ForEach(MockData_Trip.trips) { trip in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(trip.name.isEmpty ? ("Trip to " + trip.destination) : trip.name)
                                .customFont(size: 18, weight: .semibold)
                            
                            HStack(spacing: 5) {
                                // Date format will may be changed.
                                Text("From")
                                    .opacity(0.6)
                                
                                Text(trip.startDate.formatted(date: .numeric, time: .omitted))
                                    .fontWeight(.medium)
                                
                                Text("to")
                                    .opacity(0.6)
                                
                                Text(trip.endDate.formatted(date: .numeric, time: .omitted))
                                    .fontWeight(.medium)
                            }
                        }
                        .alignView(to: .leading)
                        .padding()
                        .background(Material.ultraThin)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Trip")
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView()
            .environmentObject(ViewModel())
    }
}
