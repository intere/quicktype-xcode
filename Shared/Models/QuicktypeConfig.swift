//
//  QuicktypeConfig.swift
//  quicktype-xcode
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

import Foundation

struct QuicktypeConfig {
    /// The contents of the user's clipboard (could be JSON or URL or ...)
    let clipboardContents: String
    /// The top level object type to be generated
    let topLevel: String
    /// The language to generate
    let language: Language
    /// The code generation options to pass of to quicktype
    let options: [String: Any]
}

