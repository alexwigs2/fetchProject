//
//  WebView.swift
//  fetchProject
//
//  Created by Alex Wigsmoen on 4/8/25.
//

import SwiftUI
import WebKit

struct WebView: View {
    let url: URL
    
    var body: some View {
        WebViewRepresentable(url: url)
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // You can implement additional logic to update the view here
    }
}
