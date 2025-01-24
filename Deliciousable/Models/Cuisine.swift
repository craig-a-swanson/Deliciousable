//
//  Cuisine.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/11/25.
//


/// Enumeration describing each Cuisine type found in the recipe payload.
enum Cuisine: String, Codable, CaseIterable {
    case malaysian = "Malaysian",
         british = "British",
         american = "American",
         canadian = "Canadian",
         italian = "Italian",
         tunisian = "Tunisian",
         french = "French",
         greek = "Greek",
         polish = "Polish",
         portuguese = "Portuguese",
         russian = "Russian",
         croatian = "Croatian"
}
