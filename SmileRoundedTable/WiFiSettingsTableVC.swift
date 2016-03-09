//
//  WiFiSettingsTableVC.swift
//  SmileRoundedTable
//
//  Created by yuchen liu on 2/17/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

private struct RawDataSource {
    static var count: Int {
        return data.count
    }
    static let data =  [
        [SettingsCellType.RightDetailWithDisclosureCell(text: "Wi-Fi", detailText: "None")],
        [SettingsCellType.ButtonCell(text: "Test Wi-Fi")],
        [SettingsCellType.RightDetailWithDisclosureCell(text: "Wi-Fi GHz", detailText: "2.4")],
        [
            SettingsCellType.SwitchCell(text: "Wi-Fi Connection"),
            SettingsCellType.SwitchCell(text: "Wi-Fi Manual"),
            SettingsCellType.RightDetailWithDisclosureCell(text: "When to connect", detailText: "For every picture")
        ],
        [SettingsCellType.SwitchCell(text: "Private Mode")]
    ]
}

class WiFiSettingsTableVC: UITableViewController {
    private var dataSource = Array((0..<5).map { _ in RawDataSource.data }.flatten())
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let type = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(type.identifier, forIndexPath: indexPath) as! SmileRoundedTableViewCell
        switch type {
        case .RightDetailWithDisclosureCell(let text, let detailText):
            cell.textLabel?.text = text
            cell.detailTextLabel?.text = detailText
        case .ButtonCell(let text):
            cell.textLabel?.text = text
        case .SwitchCell(let text):
            cell.textLabel?.text = text
        }
        //for test SmileRoundedTableViewCell api
        testCustomCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func testCustomCell(cell: SmileRoundedTableViewCell, indexPath: NSIndexPath) {
        let type = dataSource[indexPath.section][indexPath.row]
        switch type {
//        case .ButtonCell(_):
//            cell.selectionColor = UIColor.darkGrayColor()
//            cell.cornerRadius = 22
        case .SwitchCell(_):
            cell.selectionStyle = .None
//            cell.separatorColor = UIColor.greenColor()
            cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 50)
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        handleButtonCell(indexPath)
    }
    
    private func handleButtonCell(indexPath: NSIndexPath) {
        let type = dataSource[indexPath.section][indexPath.row]
        switch type {
        case .ButtonCell(_):
            let random = Int(arc4random()) % RawDataSource.count
            dataSource.append(RawDataSource.data[random])
            reloadTableAndScrollToBottom()
        default:
            return
        }
    }
    
    private func reloadTableAndScrollToBottom() {
        let section = self.numberOfSectionsInTableView(self.tableView) - 1
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        self.tableView.beginUpdates()
        self.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        self.tableView.endUpdates()
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top , animated: true)
    }
}
