//
//  FlutterModuleView.swift
//  IOSSpinWheelViewTest
//
//  Created by macbook on 06/03/2024.
//

import Foundation
import SwiftUI
import Flutter

struct FlutterView: UIViewControllerRepresentable {
    @EnvironmentObject var flutterEngineHolder: FlutterEngineHolder
    
    func makeUIViewController(context: Context) -> UIViewController {
        let flutterViewController = FlutterViewController(engine: flutterEngineHolder.flutterEngine!, nibName: nil, bundle: nil)
        return flutterViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the child view controller if needed
    }
}
