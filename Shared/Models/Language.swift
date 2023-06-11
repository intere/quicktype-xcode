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
    case swift, cpp, objc, objcHeader

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
}

fileprivate let languageUTIs: [String: Language] = [
    UTType.swiftSource.identifier: .swift,
    UTType.objectiveCSource.identifier: .objc,
    UTType.cHeader.identifier: .objc,
    UTType.cPlusPlusSource.identifier: .cpp,
    "com.apple.dt.playground": .swift
]
