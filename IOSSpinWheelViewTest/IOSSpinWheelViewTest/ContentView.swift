//
//  ContentView.swift
//  IOSSpinWheelViewTest
//
//  Created by macbook on 06/03/2024.
//

import SwiftUI
import Flutter

struct ContentView: View {
    @EnvironmentObject var flutterEngineHolder: FlutterEngineHolder
    @State var spinResult = ""
    @State var spinIsEnabled = true
    @State var methodChannel: FlutterMethodChannel?
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            Text("Result of SpinWheel").font(.title)
            Spacer().frame(height: 20)
            Text(spinResult).font(.title2)
            Spacer().frame(height: 30)
            VStack{
                FlutterView().frame(width: 300, height: 300)
            }.frame(maxHeight: .infinity)
            Spacer().frame(height: 30)
            Button(action: {
                methodChannel?.invokeMethod("Spin", arguments: Int.random(in: 0...7))
            }) {
                HStack {
                      Spacer()
                      Text("Spin")
                      Spacer()
                  }.padding(.vertical, 10)
            }.background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            Spacer().frame(height: 30)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.methodChannel = FlutterMethodChannel(name: "SpinIngWheelChannel", binaryMessenger: self.flutterEngineHolder.flutterEngine!.binaryMessenger)
            self.methodChannel?.setMethodCallHandler { [self] call, result in
                switch call.method {
                    case "SpinResult" :
                        self.spinResult = "\(call.arguments as! String)"
                    case "isAnimating" :
                        self.spinIsEnabled = !(call.arguments as! Bool)
                    default:
                        print("unimplemented")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
