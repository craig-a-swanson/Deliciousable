//
//  FilterView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/14/25.
//

import SwiftUI


struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedCuisines: Set<Cuisine>
    
    var body: some View {
        NavigationView {
            List(Cuisine.allCases, id: \.self) { cuisine in
                HStack {
                    Text(cuisine.rawValue)
                    Spacer()
                    if selectedCuisines.contains(cuisine) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedCuisines.contains(cuisine) {
                        selectedCuisines.remove(cuisine)
                    } else {
                        selectedCuisines.insert(cuisine)
                    }
                }
            }
            .navigationTitle("Select Cuisines")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Select All") {
                        selectedCuisines = []
                        for cuisine in Cuisine.allCases {
                            selectedCuisines.insert(cuisine)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
