//
//  SettingsMasterViewController.swift
//
//  Created by rain on 2/10/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

class SettingsMasterViewController: UITableViewController, UISplitViewControllerDelegate {

    //MARK: Property
    //collapse detail view controller when first launch in compact size class
    private var collapseDetailViewController = true
    
    let dataSource = [
        "Wi-Fi",
        "Blutooth"
    ]
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.delegate = self
    }

    // MARK: TableView Data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    //MARK: TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //when row was selected, detail view controller not collaspse in compact size class
        collapseDetailViewController = false
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let splitVC = self.splitViewController as? SettingsSplitViewController else {
            return
        }
        if splitVC.detailControllers.count > indexPath.row {
            splitVC.showDetailViewController(splitVC.detailControllers[indexPath.row], sender: indexPath)
        }
    }
    
    //MARK: UISplitViewControllerDelegate
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
    
}
