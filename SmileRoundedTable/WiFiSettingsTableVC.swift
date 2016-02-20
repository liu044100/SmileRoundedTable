//
//  WiFiSettingsTableVC.swift
//  SmileRoundedTable
//
//  Created by yuchen liu on 2/17/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit


class WiFiSettingsTableVC: UITableViewController {
    let dataSource = [
        //section 0
        [SettingsCellType.RightDetailWithDisclosureCell(text: "Wi-Fi", detailText: "None")],
        //section 1
        [SettingsCellType.ButtonCell(text: "Test Wi-Fi")],
        //section 2
        [SettingsCellType.RightDetailWithDisclosureCell(text: "Wi-Fi GHz", detailText: "2.4")],
        //section 3
        [
            SettingsCellType.SwitchCell(text: "Wi-Fi Automation Connection"),
            SettingsCellType.SwitchCell(text: "Wi-Fi Manual"),
            SettingsCellType.RightDetailWithDisclosureCell(text: "When to connect", detailText: "For every picture")
        ],
        //section 4
        [SettingsCellType.SwitchCell(text: "Private Mode")]
    ]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(type.identity, forIndexPath: indexPath)
        switch type {
        case .RightDetailWithDisclosureCell(let text, let detailText):
            cell.textLabel?.text = text
            cell.detailTextLabel?.text = detailText
        case .ButtonCell(let text):
            cell.textLabel?.text = text
        case .SwitchCell(let text):
            cell.textLabel?.text = text
            cell.selectionStyle = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
