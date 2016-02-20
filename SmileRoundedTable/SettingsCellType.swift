//
//  SettingsCellType.swift
//  SmileRoundedTable
//
//  Created by yuchen liu on 2/20/16.
//  Copyright © 2016 rain. All rights reserved.
//

import Foundation

public enum SettingsCellType: CustomStringConvertible {
    case RightDetailWithDisclosureCell(text: String, detailText: String)
    case ButtonCell(text: String)
    case SwitchCell(text: String)
    
    public var identity: String {
        let cellID: String
        switch self {
        case .RightDetailWithDisclosureCell(_, _):
            cellID = "RightDetailWithDisclosureCell"
        case .ButtonCell(_):
            cellID = "ButtonCell"
        case .SwitchCell(_):
            cellID = "SwitchCell"
        }
        return cellID
    }
    
    public var description: String {
        let cellName: String
        let separator = "***"
        switch self {
        case .RightDetailWithDisclosureCell(let text, let detailText):
            cellName = "RightDetailWithDisclosureCell\(separator)\(text)\(separator)\(detailText)"
        case .ButtonCell(let text):
            cellName = "ButtonCell\(separator)\(text)"
        case .SwitchCell(let text):
            cellName = "SwitchCell\(separator)\(text)"
        }
        return cellName
    }
}