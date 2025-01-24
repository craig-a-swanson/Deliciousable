//
//  NetworkSession.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/16/25.
//

protocol NetworkSession {
    func fetchRecipes() async throws -> [Recipe]
}
