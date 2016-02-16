//
//  WiFiSettingsTableVC.swift
//  SmileRoundedTable
//
//  Created by yuchen liu on 2/17/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

class WiFiSettingsTableVC: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
