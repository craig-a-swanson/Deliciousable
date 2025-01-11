//
//  ViewManager.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//

import SwiftUI

final class ViewManager: ObservableObject {
    
    let validURL: URL? = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    @Published var networkManager: NetworkManager!
    
    init() {
        self.networkManager = NetworkManager(url: self.validURL)
    }
    
}
