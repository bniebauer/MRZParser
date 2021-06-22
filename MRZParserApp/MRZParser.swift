//
//  MRZParser.swift
//  MRZParserApp
//
//  Created by Brenton Niebauer on 6/21/21.
//

import Foundation


class MRZParser {
    static let shared = MRZParser()
    
    func parseMRZ(from mrzString: String) -> String {
        var mrzComponents = mrzString.components(separatedBy: "<")
        
        // Remove the Country code from the Surname
        var surname = mrzComponents[1].dropFirst(3)
        
        mrzComponents.removeSubrange(0...1)
        
        // Find and append additional parts of the Surname
        let result = getName(from: mrzComponents)
        surname += result.name
        
        mrzComponents.removeSubrange(0...result.lastIndexUsed)
        
        let givenName = getName(from: mrzComponents).name
        
        return "\(givenName) \(surname)"
    }
    
    /// Obtain string values between filler characters to create part of a name
    private func getName(from components: [String]) -> (name: String, lastIndexUsed: Int) {
        var stoppedAt = 0
        var name = ""
        for i in 0...components.count - 1 {
            if components[i] == "" {
                stoppedAt = i
                break
            }
            name += " \(components[i])"
        }
        
        return (name, stoppedAt)
    }
}
