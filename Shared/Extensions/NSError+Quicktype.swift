//
//  QuicktypeError.swift
//  quicktype-xcode
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

import Foundation

extension NSError {
    static func quicktypeError(_ message: String, details: String = "No details") -> NSError {
        NSError(
            domain: "quicktype",
            code: 1,
            userInfo: [
                NSLocalizedDescriptionKey: NSLocalizedString(message, comment: ""),
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(details, comment: "")
            ]
        )
    }
}
