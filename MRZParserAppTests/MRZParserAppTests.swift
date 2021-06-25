//
//  MRZParserAppTests.swift
//  MRZParserAppTests
//
//  Created by Brenton Niebauer on 6/25/21.
//

import XCTest
@testable import MRZParserApp

class MRZParserAppTests: XCTestCase {
    
    var mrzTestStrings: [String] = []
    var mrzPassingTestData: [MRZData] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mrzTestStrings = [
            "P<USARICHARDS<STEVENS<JR<<GEORGE<MICHAEL<<<<123456A<<5USA8502201F2001012<<<<<<<<<<<<<<08",
            "P<USAROGGER<<MICHAEL<<<<<<<<<<<<<<<<<<<<<<<<YA11164461USA8502201M2001023<<<<<<<<<<<<<<00",
            "P<USAROGGER<<MICHAEL<JOHN<<<<<<<<<<<<<<<",
            "PCIRLOSHEA<DONNLEY<<KELSEY<<<<"
        ]
        mrzPassingTestData = [
            MRZData(type: "P", countryType: nil, countryCode: "USA", givenName: "GEORGE MICHAEL", surName: "RICHARDS STEVENS JR"),
            MRZData(type: "P", countryType: nil, countryCode: "USA", givenName: "MICHAEL", surName: "ROGGER"),
            MRZData(type: "P", countryType: nil, countryCode: "USA", givenName: "MICHAEL JOHN", surName: "ROGGER"),
            MRZData(type: "P", countryType: "C", countryCode: "IRL", givenName: "KELSEY", surName: "OSHEA DONNLEY")
        ]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCountryCode() throws {
        for i in 0...mrzTestStrings.count - 1 {
            if let result = try! MRZParser.shared.parseMRZ(from: mrzTestStrings[i]) {
                XCTAssert(result.countryCode == mrzPassingTestData[i].countryCode)
            }
        }
    }
    
    func testGivenName() throws {
        for i in 0...mrzTestStrings.count - 1 {
            if let result = try! MRZParser.shared.parseMRZ(from: mrzTestStrings[i]) {
                XCTAssert( result.givenName == mrzPassingTestData[i].givenName)
            }
        }
        
    }
    
    func testSurName() throws {
        for i in 0...mrzTestStrings.count - 1 {
            if let result = try! MRZParser.shared.parseMRZ(from: mrzTestStrings[i]) {
                XCTAssert(result.surName == mrzPassingTestData[i].surName)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
