//
//  ContentView.swift
//  Example
//
//  Created by Mateusz on 26/08/2023.
//

import Ramp
import SwiftUI
import WebKit

struct ContentView: View {
    @State private var rampPresented: Bool = false
    @State private var sumsubPresented: Bool = false
    @State private var url: String = ""
    
    var body: some View {
        VStack {
            TextField("URL", text: $url)
                .textFieldStyle(.roundedBorder)
                .textContentType(.URL)
            Button("Show Ramp") {
                rampPresented = true
            }
            Button("Show WebView") {
                sumsubPresented = true
            }
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $rampPresented) {
            RampView(configuration: url.isEmpty ? .dev : .withUrl(url))
        }
        .sheet(isPresented: $sumsubPresented) {
            WebView(url: try! Configuration.dev.buildUrl())
        }
    }
}

private extension Ramp.Configuration {
    static func withUrl(_ url: String) -> Configuration {
        var configuration = Configuration()
        configuration.url = url
        return configuration
    }
    
    static var dev: Configuration {
        var configuration = Configuration()
        configuration.url = "https://app.dev.ramp-network.org"
        configuration.hostAppName = "Flutter App"
        configuration.hostApiKey = "3qncr4yvxfpro6endeaeu6npkh8qc23e9uadtazq"
        configuration.enabledFlows = [.onramp, .offramp]
        configuration.defaultFlow = .onramp
        configuration.userEmailAddress = "mateusz.jablonski@ramp.network"
        configuration.fiatCurrency = "EUR"
        configuration.fiatValue = "2"
        configuration.swapAsset = "GOERLI_ETH"
        configuration.userAddress = "0x71C7656EC7ab88b098defB751B7401B5f6d8976F"
        configuration.useSendCryptoCallback = true
        return configuration
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RampView: UIViewControllerRepresentable {
    let configuration: Configuration
    
    func makeUIViewController(context: Context) -> Ramp.RampViewController {
        try! RampViewController(configuration: configuration)
    }
    
    func updateUIViewController(_ uiViewController: Ramp.RampViewController, context: Context) {
        //
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
