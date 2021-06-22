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
        // Convert the string to an array of characters
        var mrzParts: [Character] = []
        mrzString.map({ mrzParts.append($0)})
        
        // Find and append additional parts of the Surname
        let result = getName(from: mrzParts, startingAt: 5)
        let surname = result.name
        
        let givenName = getName(from: mrzParts, startingAt: result.lastIndexUsed+2).name
        
        return "\(givenName) \(surname)"
    }
    
    /// Obtain string values between filler characters to create part of a name
    private func getName(from components: [Character], startingAt: Int) -> (name: String, lastIndexUsed: Int) {
        let filler: Character = "<"
        var stoppedAt = 0
        var name: [Character] = []
        
        for i in startingAt...components.count - 1 {
            if components[i] == filler && components[i + 1] == filler {
                stoppedAt = i
                break
            } else if components[i] == filler {
                name.append(" ")
            } else {
                name.append(components[i])
            }
        }
        
        return (String(name), stoppedAt)
    }
}
