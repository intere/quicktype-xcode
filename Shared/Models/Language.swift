//
//  Language.swift
//  quicktype
//
//  Created by Eric Internicola on 6/10/23.
//  Copyright © 2023 quicktype. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

enum Language: String {
    case swift
    case cpp
    case objc
    case objcHeader

    /// Gets you the language associated with the provided UTI string
    static func languageFor(contentUTI utiString: String) -> Language? {
        guard let contentUTI = UTType(utiString) else { return nil }

        for (uti, language) in languageUTIs {
            guard let languageUTI = UTType(uti) else { continue }

            if contentUTI.conforms(to: languageUTI) {
                return language
            }
        }
        return nil
    }

    /// Gets you the default command options associated with the language
    var commandOptions: [String: Any] {
        switch self {
        case .cpp:
            // https://github.com/quicktype/quicktype/blob/master/packages/quicktype-core/src/language/CPlusPlus.ts
            return [:]

        case .objc:
            // https://github.com/quicktype/quicktype/blob/master/packages/quicktype-core/src/language/Objective-C.ts
            return [
                // Objective-C is not ideal yet, so extra comments are useful
                "extra-comments": true
            ]

        case .objcHeader:
            // https://github.com/quicktype/quicktype/blob/master/packages/quicktype-core/src/language/Objective-C.ts
            return [
                "features": "interface"
            ]

        case .swift:
            // https://github.com/quicktype/quicktype/blob/master/packages/quicktype-core/src/language/Swift.ts
            return [
                "initializers": true,
                "access-level": "public",
                "protocol": "equatable",
                "swift5Support": true
            ]
        }
    }
}

/// Map of Language UTIs to language enum value
fileprivate let languageUTIs: [String: Language] = [
    UTType.swiftSource.identifier: .swift,
    UTType.objectiveCSource.identifier: .objc,
    UTType.cHeader.identifier: .objc,
    UTType.cPlusPlusSource.identifier: .cpp,
    "com.apple.dt.playground": .swift
]
