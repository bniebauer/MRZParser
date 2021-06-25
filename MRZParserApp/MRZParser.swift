//
//  MRZParser.swift
//  MRZParserApp
//
//  Created by Brenton Niebauer on 6/21/21.
//

import Foundation


class MRZParser {
    static let shared = MRZParser()
    
    enum ParserError: Error {
        case argumentInvalid
        case invalidFillerCharacter(characterNeeded: Character)
    }
    
    func parseMRZ(from mrzString: String) throws -> MRZData? {
        if mrzString.isEmpty {
            throw ParserError.argumentInvalid
        }
        // Convert the string to an array of characters
        var mrzParts: [Character] = []
        mrzString.map({ mrzParts.append($0)})
        
        var mrzData = MRZData()
        mrzData.type = String(mrzParts[0])
        
        if mrzParts[1] != "<" {
            mrzData.countryType = String(mrzParts[1])
        }
        
        mrzData.countryCode = getCountryCode(from: mrzParts)
        // Find and append additional parts of the Surname
        let result: (name:String, lastIndexUsed: Int)
        do {
            try result = getName(from: mrzParts, startingAt: 5)
        } catch ParserError.invalidFillerCharacter(let charNeeded) {
            print("MRZ String does not contain filler character: \(charNeeded)")
            throw ParserError.argumentInvalid
        }
        mrzData.surName = result.name
        
        do {
            try mrzData.givenName = getName(from: mrzParts, startingAt: result.lastIndexUsed+2).name
        } catch {
            print(error)
        }
        
        
        return mrzData
    }
    
    private func getCountryCode(from components: [Character]) -> String {
        let startingIndex = 2
        let endingIndex = 4
        var countryCode = [Character]()
        for i in startingIndex...endingIndex {
            countryCode.append(components[i])
        }
        
        return String(countryCode)
    }
    
    /// Obtain string values between filler characters to create part of a name
    private func getName(from components: [Character], startingAt: Int) throws -> (name: String, lastIndexUsed: Int) {
        if !components.contains("<") {
            throw ParserError.invalidFillerCharacter(characterNeeded: "<")
        }
        
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
