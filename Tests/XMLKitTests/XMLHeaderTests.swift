//
//  XMLHeaderTests.swift
//
//
//  Created by 黄磊 on 2020-03-24.
//

import XCTest
@testable import XMLKit

final class XMLHeaderTests: XCTestCase {
    func testVersion() throws {
        let header = XMLHeader(version: 1.0)
        let str = header.toXML()
        
        XCTAssertNotNil(str)
        XCTAssertEqual(str, "<?xml version=\"1.0\"?>\n")
    }
    
    func testEncoding() throws {
        let header = XMLHeader(version: 1.0, encoding: "utf-8")
        let str = header.toXML()
        
        XCTAssertNotNil(str)
        XCTAssertEqual(str, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
    }
    
    func testStandalone() throws {
        let header = XMLHeader(version: 1.0, standalone: "yes")
        let str = header.toXML()
        
        XCTAssertNotNil(str)
        XCTAssertEqual(str, "<?xml version=\"1.0\" standalone=\"yes\"?>\n")
    }
    
    func testHeaderInXML() throws {
        let header = XMLHeader(version: 1.0, encoding: "utf-8")
        
        let user = User(id: s_int, name: s_str)
        let data = try XMLEncoder().encode(user, withRootKey: "user", header: header)
        let result = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(result, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<user><id>\(s_int)</id><name>\(s_str)</name></user>")
    }
}
