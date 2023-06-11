//
//  Command.swift
//  quicktype-xcode
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

import Foundation

// Commands correspond to definitions in Info.plist
enum Command: String {
    case pasteJSONAsCode = "PasteJSONAsCode"
    case pasteJSONAsObjCHeader = "PasteJSONAsObjCHeader"
    case pasteJSONAsObjCImplementation = "PasteJSONAsObjCImplementation"

    /// "com.intere.quicktype-xcode.X" -> Command(rawValue: "X")
    static func from(identifier: String) -> Command? {
        guard let component = identifier.split(separator: ".").last else {
            return nil
        }
        return Command(rawValue: String(component))
    }
}
