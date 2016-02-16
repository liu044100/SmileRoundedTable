//
//  SettingsSplitViewController.swift
//
//  Created by yuchen liu on 2/10/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

//Settings Element Storyboard Name
enum SettingsElement: String {
    case WiFi = "WiFiSettings"
    case Bluetooth = "BluetoothSettings"
    static let allElements = [WiFi, Bluetooth]
}

class SettingsSplitViewController: UISplitViewController {
    
    var detailControllers = [UINavigationController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //show splitView in any size class
        self.preferredDisplayMode = .AllVisible
        
        //append vc in right
        self.createDetailControllers()
        
        //set origin right vc
        self.viewControllers = [self.viewControllers.first!, detailControllers[0]]
    }
    
    private func createDetailControllers() {
        for element in SettingsElement.allElements {
            let storyboard = UIStoryboard(name: element.rawValue, bundle: nil)
            guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else {
                continue
            }
            detailControllers.append(vc)
        }
    }
}
