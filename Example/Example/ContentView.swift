//
//  ContentView.swift
//  Example
//
//  Created by Mateusz on 26/08/2023.
//

import Ramp
import SwiftUI

struct ContentView: View {
    @State private var rampPresented: Bool = false
    
    var body: some View {
        Button("Show Ramp") {
            rampPresented = true
        }
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $rampPresented) {
            RampView(configuration: Configuration())
        }
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
