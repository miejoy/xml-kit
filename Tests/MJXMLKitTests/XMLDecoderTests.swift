//
//  XMLDecoderTests.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

import XCTest
import MJXMLKit

final class XMLDecoderTests: XCTestCase {
    
    func testNormal() throws {
        
        let data = userXMLStrNarmal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(User.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testNoOption() throws {
        
        let data = userXMLStrNoOption.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(User.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testAttrNormal() throws {
        
        let data = userAttrXMLStrNormal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserAttr.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testAttrNoOption() throws {
        
        let data = userAttrXMLStrNoOption.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserAttr.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testMixNormal() throws {
        
        let data = userMixXMLStrNormal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserMix.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testMixNoOption() throws {
        
        let data = userMixXMLStrNoOption.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserMix.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testPlaintext() throws {
        
        let data = userPlaintextXMLStrNormal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserPlaintext.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.content, s_str)
    }
    
    func testPlaintextOption() throws {
        
        let data = userPlaintextXMLStrNormal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserPlaintextOption.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.content, s_str)
    }
    
    func testPlaintextNoOption() throws {
        
        let data = userPlaintextXMLStrNoOption.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(UserPlaintextOption.self, from: data)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertNil(user.content)
    }
    
    
    // MARK: - Container
    
    func testNestedContainer() throws {
        
        let data = bookXMLStrNormal.data(using: .utf8)!
        
        let book = try XMLDecoder().decode(Book.self, from: data)
        let user = book.owner
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testNestedContainerNoOption() throws {
        
        let data = bookXMLStrNoOption.data(using: .utf8)!
        
        let book = try XMLDecoder().decode(Book.self, from: data)
        let user = book.owner
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    
    func testOptionNestedContainer() throws {
        
        let data = bookXMLStrNormal.data(using: .utf8)!
        
        let book = try XMLDecoder().decode(BookOption.self, from: data)
        let user = book.owner!
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testOptionNestedContainerAllAttr() throws {
        
        let data = bookXMLStrAllAttr.data(using: .utf8)!
        
        let book = try XMLDecoder().decode(BookAllAttr.self, from: data)
        
        let user = book.owner!
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)

    }
    
    func testOptionNestedContainerNoOption() throws {
        
        let data = bookXMLStrNoOption.data(using: .utf8)!
        
        let book = try XMLDecoder().decode(BookOption.self, from: data)
        let user = book.owner!
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testNestedUnkeyedContainer() throws {
        
        // 下面两个都可以成功解析
        let data = userBookXMLStrNormal.data(using: .utf8)!
//        let data = userBookXMLStrDic.data(using: .utf8)!
        
        let userBook = try XMLDecoder().decode(UserBook.self, from: data)
        let books = userBook.books
        let firstOwner = books.first!.owner
        let secondOwner = books.last!.owner
        
        XCTAssertEqual(userBook.id, s_int)
        XCTAssertEqual(userBook.name, s_str)
        XCTAssertEqual(firstOwner.id, s_int)
        XCTAssertNil(firstOwner.alias)
        XCTAssertEqual(firstOwner.name, s_str)
        XCTAssertNil(firstOwner.age)
        XCTAssertEqual(secondOwner.id, s_int)
        XCTAssertEqual(secondOwner.alias, s_strOption)
        XCTAssertEqual(secondOwner.name, s_str)
        XCTAssertEqual(secondOwner.age, s_intOption)
        
    }
    
    func testNestedUnkeyedContainerDic() throws {

        let data = userBookXMLStrDic.data(using: .utf8)!
        
        let userBook = try XMLDecoder().decode(UserBookDic.self, from: data)
        let books = userBook.books
        let firstOwner = books["book1"]!.owner
        let secondOwner = books["book2"]!.owner
        
        XCTAssertEqual(userBook.id, s_int)
        XCTAssertEqual(userBook.name, s_str)
        XCTAssertEqual(firstOwner.id, s_int)
        XCTAssertNil(firstOwner.alias)
        XCTAssertEqual(firstOwner.name, s_str)
        XCTAssertNil(firstOwner.age)
        XCTAssertEqual(secondOwner.id, s_int)
        XCTAssertEqual(secondOwner.alias, s_strOption)
        XCTAssertEqual(secondOwner.name, s_str)
        XCTAssertEqual(secondOwner.age, s_intOption)

    }
    
    
    func testOptionNestedUnkeyedContainer() throws {
        
        let data = userBookXMLStrNormal.data(using: .utf8)!
        
        let userBook = try XMLDecoder().decode(UserBookOption.self, from: data)
        let books = userBook.books!
        let firstOwner = books.first!.owner
        let secondOwner = books.last!.owner
        
        XCTAssertEqual(userBook.id, s_int)
        XCTAssertEqual(userBook.name, s_str)
        XCTAssertEqual(firstOwner.id, s_int)
        XCTAssertNil(firstOwner.alias)
        XCTAssertEqual(firstOwner.name, s_str)
        XCTAssertNil(firstOwner.age)
        XCTAssertEqual(secondOwner.id, s_int)
        XCTAssertEqual(secondOwner.alias, s_strOption)
        XCTAssertEqual(secondOwner.name, s_str)
        XCTAssertEqual(secondOwner.age, s_intOption)
        
    }
    
    
    
    func testOptionNestedUnkeyedContainerNoOption() throws {
        
        let data = userBookXMLStrNormal.data(using: .utf8)!
        
        let userBook = try XMLDecoder().decode(UserBookOption.self, from: data)
        let books = userBook.books!
        let firstOwner = books.first!.owner
        let secondOwner = books.last!.owner
        
        XCTAssertEqual(userBook.id, s_int)
        XCTAssertEqual(userBook.name, s_str)
        XCTAssertEqual(firstOwner.id, s_int)
        XCTAssertNil(firstOwner.alias)
        XCTAssertEqual(firstOwner.name, s_str)
        XCTAssertNil(firstOwner.age)
        XCTAssertEqual(secondOwner.id, s_int)
        XCTAssertEqual(secondOwner.alias, s_strOption)
        XCTAssertEqual(secondOwner.name, s_str)
        XCTAssertEqual(secondOwner.age, s_intOption)
        
    }
    
    func testOptionSingleContainerAllAttr() throws {
        
        let data = userBookXMLStrAllAttr.data(using: .utf8)!
        
        let userBook = try XMLDecoder().decode(UserBookAllAttr.self, from: data)
        let books = userBook.books
        let firstBook = books.first!!
        let secondBook = books.last!!
        
        XCTAssertEqual(userBook.id, s_int)
        XCTAssertEqual(userBook.name, s_str)
        XCTAssertEqual(firstBook.id, s_int)
        XCTAssertEqual(firstBook.alias, s_strOption)
        XCTAssertEqual(secondBook.id, s_int)
        XCTAssertNil(secondBook.alias)

    }
    
    
    // MAKR: - Inherit
    
    
    
    
    func testInherit() throws {
        
        let data = squareXMLStr.data(using: .utf8)!
        
        let square = try XMLDecoder().decode(Square.self, from: data)
        
        XCTAssertEqual(square.id, s_int)
        XCTAssertEqual(square.name, s_str)
        XCTAssertEqual(square.size, s_int)
        XCTAssertEqual(square.commonName, s_strOption)
        
    }
    
    func testNSInheritWithSupper() throws {
        
        let data = squareXMLStr.data(using: .utf8)!
        
        let square = try XMLDecoder().decode(NSSquare.self, from: data)
        
        XCTAssertEqual(square.id, s_int)
        XCTAssertEqual(square.name, s_str)
        XCTAssertEqual(square.size, s_int)
        XCTAssertEqual(square.commonName, s_strOption)
        
    }
    
    
}
