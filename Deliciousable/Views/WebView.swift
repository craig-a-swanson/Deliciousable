//
//  WebView.swift
//  Deliciousable
//
//  Created by Craig Swanson on 1/10/25.
//

import SwiftUI
import WebKit

/// Bridge a WKWebView to SwiftUI in order to present a web view while remaining in the app.
struct WebView: UIViewRepresentable {
    
    let recipeURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: recipeURL)
        webView.load(request)
    }
}
