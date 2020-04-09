//
//  Extensions.swift
//  swiftpress
//
//  Created by chancee on 16/12/2019.
//

import Foundation

//  MARK: Sequence
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

//  MARK: Date
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
    
    static let RFC822: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.timeZone = TimeZone(identifier: "Z")
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    var RFC822Date: Date? {
        return String.RFC822.date(from: self)
    }
}

//  MARK: Colours
func + (left: Colours, right: String) -> String {
    return left.rawValue + right
}
enum Colours: String {
    case CORAL = "\u{001B}[38;5;211m"
    case PEACH = "\u{001B}[38;5;217m"
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case base = "\u{001B}[0;0m"

    func name() -> String {
        switch self {
        case .CORAL: return "CORAL"
        case .PEACH: return "PEACH"
        case .black: return "Black"
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .magenta: return "Magenta"
        case .cyan: return "Cyan"
        case .white: return "White"
        case .base: return "Base"
        }
    }

    static func all() -> [Colours] {
        return [.PEACH, .CORAL, .black, .red, .green, .yellow, .blue, .magenta, .cyan, .white, .base]
    }
}
