//
//  WiFiTableVC.swift
//  SmileRoundedTable
//
//  Created by yuchen liu on 2/20/16.
//  Copyright © 2016 rain. All rights reserved.
//

import UIKit

class WiFiTableVC: UITableViewController {
    //MARK: Property
    private var dataSource = [Int](2..<50)
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None
        //self.tableView.separatorColor = UIColor.purpleColor()
        //self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0)
    }
    
    // MARK: TableView data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        return cell
    }
    
    //MARK: TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
