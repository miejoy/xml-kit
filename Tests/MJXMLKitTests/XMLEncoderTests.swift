//
//  XMLEncoderTests.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

import XCTest
import MJXMLKit

final class XMLEncoderTests: XCTestCase {
    
    func testNormal() throws {
        
        let data = userXMLStrNarmal.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(User.self, from: data)
        let encoder = XMLEncoder()
        encoder.outputFormatting = .prettyPrinted
        let result = try encoder.encode(user, withRootKey: "user")
        
        XCTAssertEqual(data.base64EncodedString(), result.base64EncodedString())
        
    }
    
    func testNoOption() throws {
        
        let data = userXMLStrNoOption.data(using: .utf8)!
        
        let user = try XMLDecoder().decode(User.self, from: data)
        let encoder = XMLEncoder()
        encoder.outputFormatting = .prettyPrinted
        let result = try encoder.encode(user, withRootKey: "user")
        
        XCTAssertEqual(data.base64EncodedString(), result.base64EncodedString())
        
    }
    
    func testAttrNormal() throws {
        
        let data = userAttrXMLStrNormal.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserAttr.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserAttr.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)
        
    }
    
    func testAttrNoOption() throws {
        
        let data = userAttrXMLStrNoOption.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserAttr.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserAttr.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testMixNormal() throws {
        
        let data = userMixXMLStrNormal.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserMix.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserMix.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.name, s_str)
        XCTAssertEqual(user.age, s_intOption)

    }
    
    func testMixNoOption() throws {
        
        let data = userMixXMLStrNoOption.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserMix.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserMix.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testPlaintext() throws {
        
        let data = userPlaintextXMLStrNormal.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserPlaintext.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserPlaintext.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.content, s_str)
    }
    
    func testPlaintextOption() throws {
        
        let data = userPlaintextXMLStrNormal.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserPlaintextOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserPlaintextOption.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertEqual(user.content, s_str)
    }
    
    func testPlaintextNoOption() throws {
        
        let data = userPlaintextXMLStrNoOption.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserPlaintextOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserPlaintextOption.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.alias, s_strOption)
        XCTAssertNil(user.content)
    }
    
    func testBrothersOption() throws {
        
        let data = userBrothersXMLStrNoOption.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserBrothers.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserBrothers.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.name, s_str)
        XCTAssert(user.brothers.isEmpty)
    }
    
    func testBrothersNoOption() throws {
        
        let data = userBrothersXMLStrNormal.data(using: .utf8)!
        
        let tmpUser = try XMLDecoder().decode(UserBrothers.self, from: data)
        let newData = try XMLEncoder().encode(tmpUser, withRootKey: "user")
        let user = try XMLDecoder().decode(UserBrothers.self, from: newData)
        
        XCTAssertEqual(user.id, s_int)
        XCTAssertEqual(user.name, s_str)
        let brother = user.brothers.first!
        let sencond = user.brothers[1]
        XCTAssertEqual(brother.id, s_int)
        XCTAssertEqual(brother.alias, s_strOption)
        XCTAssertEqual(brother.age, s_intOption)
        XCTAssertEqual(brother.name, s_str)
        XCTAssertEqual(sencond.id, s_int)
        XCTAssertEqual(sencond.alias, s_strOption)
        XCTAssertEqual(sencond.age, s_intOption)
        XCTAssertEqual(sencond.name, s_str)
    }
    
    
    // MARK: - Container
    
    func testNestedContainer() throws {
        
        let data = bookXMLStrNormal.data(using: .utf8)!
        
        let tmpBook = try XMLDecoder().decode(Book.self, from: data)
        let newData = try XMLEncoder().encode(tmpBook, withRootKey: "book")
        let book = try XMLDecoder().decode(Book.self, from: newData)
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
        
        let tmpBook = try XMLDecoder().decode(Book.self, from: data)
        let newData = try XMLEncoder().encode(tmpBook, withRootKey: "book")
        let book = try XMLDecoder().decode(Book.self, from: newData)
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
        
        let tmpBook = try XMLDecoder().decode(BookOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpBook, withRootKey: "book")
        let book = try XMLDecoder().decode(BookOption.self, from: newData)
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
        
        let tmpBook = try XMLDecoder().decode(BookAllAttr.self, from: data)
        let newData = try XMLEncoder().encode(tmpBook, withRootKey: "book")
        let book = try XMLDecoder().decode(BookAllAttr.self, from: newData)
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
        
        let tmpBook = try XMLDecoder().decode(BookOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpBook, withRootKey: "book")
        let book = try XMLDecoder().decode(BookOption.self, from: newData)
        let user = book.owner!
        
        XCTAssertEqual(book.id, s_int)
        XCTAssertEqual(book.name, s_str)
        XCTAssertEqual(user.id, s_int)
        XCTAssertNil(user.alias)
        XCTAssertEqual(user.name, s_str)
        XCTAssertNil(user.age)
        
    }
    
    func testNestedUnkeyedContainer() throws {
        
        let data = userBookXMLStrNormal.data(using: .utf8)!
        
        let tmpUserBook = try XMLDecoder().decode(UserBook.self, from: data)
        let newData = try XMLEncoder().encode(tmpUserBook, withRootKey: "user")
        let userBook = try XMLDecoder().decode(UserBook.self, from: newData)
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
        
        let tmpUserBook = try XMLDecoder().decode(UserBook.self, from: data)
        let newData = try XMLEncoder().encode(tmpUserBook, withRootKey: "user")
        let userBook = try XMLDecoder().decode(UserBookDic.self, from: newData)
        let books = userBook.books
        let firstOwner = books["Index0"]!.owner
        let secondOwner = books["Index1"]!.owner
        
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
        
        let tmpUserBook = try XMLDecoder().decode(UserBookOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpUserBook, withRootKey: "user")
        let userBook = try XMLDecoder().decode(UserBookOption.self, from: newData)
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
        
        let tmpUserBook = try XMLDecoder().decode(UserBookOption.self, from: data)
        let newData = try XMLEncoder().encode(tmpUserBook, withRootKey: "user")
        let userBook = try XMLDecoder().decode(UserBookOption.self, from: newData)
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
        
        let tmpUserBook = try XMLDecoder().decode(UserBookAllAttr.self, from: data)
        let newData = try XMLEncoder().encode(tmpUserBook, withRootKey: "user")
        let userBook = try XMLDecoder().decode(UserBookAllAttr.self, from: newData)
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
        
        let tmpSquare = try XMLDecoder().decode(Square.self, from: data)
        let newData = try XMLEncoder().encode(tmpSquare, withRootKey: "square")
        let square = try XMLDecoder().decode(Square.self, from: newData)
        
        XCTAssertEqual(square.id, s_int)
        XCTAssertEqual(square.name, s_str)
        XCTAssertEqual(square.size, s_int)
        XCTAssertEqual(square.commonName, s_strOption)

    }
    
    func testNSInheritWithSupper() throws {
        
        let data = squareXMLStr.data(using: .utf8)!
        
        let tmpSquare = try XMLDecoder().decode(NSSquare.self, from: data)
        let newData = try XMLEncoder().encode(tmpSquare, withRootKey: "square")
        let square = try XMLDecoder().decode(NSSquare.self, from: newData)
        
        XCTAssertEqual(square.id, s_int)
        XCTAssertEqual(square.name, s_str)
        XCTAssertEqual(square.size, s_int)
        XCTAssertEqual(square.commonName, s_strOption)
        
    }
    
    
}
