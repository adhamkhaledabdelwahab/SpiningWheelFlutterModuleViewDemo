//
//  ViewController.swift
//  MyIOSTestApp
//
//  Created by macbook on 04/03/2024.
//

import UIKit
import Flutter

class ViewController: UIViewController {
    
    var flutterViewController: FlutterViewController!
    var methodChannel: FlutterMethodChannel!
    
    @IBOutlet weak var spinResult: UILabel!
    @IBOutlet weak var spin: UIButton!
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        // Create a FlutterViewController
        flutterViewController = FlutterViewController(nibName: nil, bundle: nil)
        methodChannel = FlutterMethodChannel(name: "SpinIngWheelChannel", binaryMessenger: flutterViewController.binaryMessenger)
        
        methodChannel?.setMethodCallHandler { call, result in
            
            switch call.method {
                case "SpinResult" :
                    self.spinResult.text = "\(call.arguments as! String)"
                case "isAnimating" :
                    self.spin.isEnabled = !(call.arguments as! Bool)
                default:
                    print("unimplemented")
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Flutter view constraints (e.g., position and size)
        flutterViewController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        flutterViewController.view.center = view.center
        flutterViewController.view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        flutterViewController.view.backgroundColor = UIColor.clear
        // Add Flutter view as a subview
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.didMove(toParent: self)

        spinResult.text = ""

    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        methodChannel.invokeMethod("Spin", arguments: Int.random(in: 0...7))
    }
    
}

