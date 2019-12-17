//
//  Extensions.swift
//  swiftpress
//
//  Created by chancee on 16/12/2019.
//

import Foundation

public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

extension String {
    static let shortDateUK: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    var shortDateUK: Date? {
        return String.shortDateUK.date(from: self)
    }
}
