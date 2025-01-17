//
//  EmptyStateView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/16/25.
//

import SwiftUI

struct EmptyStateView: View {
    
    @EnvironmentObject var viewModel: RecipeViewModel
    @Binding var showEmptyState: Bool
    @Binding var showAlert: Bool
    
    var body: some View {
        ScrollView {
            Text("No Recipes to Show!")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.vertical, 50)
                .padding(.horizontal, 40)
            Image("DeliciousableIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(0.45)
        }
        .refreshable {
            do {
                try await viewModel.fetchRecipes()
                self.showEmptyState = viewModel.recipes.isEmpty
            } catch {
                withAnimation {
                    self.showAlert = true
                }
            }
        }
    }
}
