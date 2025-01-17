//
//  NetworkErrors.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/16/25.
//

enum NetworkErrors: Error {
    case invalidURL
    case fetchDataError
    case decodingError
    case invalidResponse
}
