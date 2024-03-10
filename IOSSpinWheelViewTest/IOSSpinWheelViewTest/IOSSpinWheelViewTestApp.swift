//
//  IOSSpinWheelViewTestApp.swift
//  IOSSpinWheelViewTest
//
//  Created by macbook on 06/03/2024.
//

import SwiftUI
import FlutterPluginRegistrant
import Flutter

@main
struct IOSSpinWheelViewTestApp: App {
    @StateObject var flutterEngineHolder = FlutterEngineHolder()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flutterEngineHolder)
        }
    }
}
