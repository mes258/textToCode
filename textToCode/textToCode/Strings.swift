//
//  Strings.swift
//  textToCode
//
//  from https://gist.github.com/reitzig/67b41e75176ddfd432cb09392a270218
//
//

import Foundation

fileprivate let badChars = CharacterSet.alphanumerics.inverted

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        
        let parts = self.components(separatedBy: badChars)
        
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})
        
        return ([first] + rest).joined(separator: "")
    }
}
