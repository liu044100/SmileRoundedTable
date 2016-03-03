//: Playground - noun: a place where people can play

import UIKit

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

let cell = SettingsCellType.RightDetailWithDisclosureCell(text: "Printer", detailText: "None")
let name = "\(cell)"

public protocol SettingsList: CustomStringConvertible {}

extension String: SettingsList {
    public var description: String {
        return self
    }
}

func showgo() -> [SettingsList] {
    return ["go", "gogo"]
}

let a: [SettingsList] = showgo()

