//
//  FlutterEngineClass.swift
//  IOSSpinWheelViewTest
//
//  Created by macbook on 06/03/2024.
//

import Foundation
import Flutter

class FlutterEngineHolder: ObservableObject {
    @Published var flutterEngine: FlutterEngine?

    init() {
        flutterEngine = FlutterEngine(name: "MyFlutterEngine")
        print("Flutter engine initialized: \(flutterEngine!)")
        flutterEngine?.run()
    }
}
