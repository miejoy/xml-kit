//
//  DataForTest.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation
import XMLKit

internal struct XMLKey : CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index\(index)"
        self.intValue = index
    }
}

struct User : Codable {
    
    var id : Int
    
    var alias : String?
    
    var name : String
    
    var age : Int?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct UserAttr : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
    
    @Attr var name : String
    
    @Attr var age : Int?
    
}

struct UserPlaintext : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
        
    @Plaintext var content : String
    
}

struct UserPlaintextOption : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
        
    @Plaintext var content : String?
    
}

struct UserBrothers : Codable {
    
    @Attr var id : Int
    
    var name : String
        
    @Brothers var brothers : [UserMix]
    
}

//struct UserBrothersOption : Codable {
//
//    @Attr var id : Int
//
//    var name : String
//
//    @Brothers var brothers : [UserMix]?
//
//}

struct UserMix : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
    
    var name : String
    
    var age : Int?
}


// MARK: - Container

struct Book : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var owner : UserMix

}

struct BoolAttr : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
}



struct BookOption : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var owner : UserMix?
    
}

struct BookAllAttr : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var owner : UserAttr?
    
}

struct UserBook : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var books : [Book]
    
}

struct UserBookOption : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var books : [Book]?
    
}

struct UserBookDic : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var books : [String:Book]
    
}

struct UserBookAllAttr : Codable {
    
    @Attr var id : Int
    
    var name : String
    
    var books : [BoolAttr?]
    
}

class Shape : Codable {
    
    @Attr var id : Int
    
    var name : String = ""
    
}

class Square: Shape {
    
    @Attr var size : Int
    
    var commonName : String
    
    enum CodingKeys : String, CodingKey {
        case size
        case commonName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commonName = try container.decode(String.self, forKey: .commonName)
        self._size = try container.decode(Attr<Int>.self, forKey: .size)
        try super.init(from: decoder)
        
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commonName, forKey: .commonName)
        try container.encode(_size, forKey: .size)
        try super.encode(to: encoder)
    }
    
}

class NSShape: NSObject, Codable {
    
    @Attr var id : Int
    
    var name : String
}

class NSSquare: NSShape {

    @Attr var size : Int

    var commonName : String = ""
    
    enum CodingKeys : String, CodingKey {
        case size
        case commonName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commonName = try container.decode(String.self, forKey: .commonName)
        self._size = try container.decode(Attr<Int>.self, forKey: .size)
        // 这里因为container 中没有 super， 所以下面调用与 super.init(from: decoder) 是一致的
        try super.init(from: container.superDecoder())
        
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commonName, forKey: .commonName)
        try container.encode(_size, forKey: .size)
        // 与 decoder 相同
        try super.encode(to: container.superEncoder())
//        try super.encode(to: encoder)
    }
    
}


// MARK: - Strategy

struct DateStrategy : Codable {
    
    @Attr var createTime : Date
    
    @Attr var updateTime : Date?
    
    var createDate : Date
    
    var updateDate : Date?
    
}

struct DataStrategy : Codable {
    
    @Attr var dataAttr : Data
    
    @Attr var dataAttrOption : Data?
    
    var data : Data
    
    var dataOption : Data?
    
}

struct FloatStrategy : Codable {
    
    @Attr var floatAttr : Float
    
    @Attr var floatAttrOption : Float?
    
    var float : Float
    
    var floatOption : Float?
    
}

struct DoubleStrategy : Codable {
    
    @Attr var floatAttr : Double
    
    @Attr var floatAttrOption : Double?
    
    var float : Double
    
    var floatOption : Double?
    
}

// MARK: - Key

struct ElementName : Codable {
    
    var elementName : Int
    
    var elementNameOption : Int?
}

struct AttrName : Codable {
    
    @Attr var attrName : String
    
    @Attr var attrNameOption : String?
}

// MARK: - Cover More

struct AllCover: Codable {
    @Attr var boolA: Bool
    @Attr var intA: Int
    @Attr var int8A: Int8
    @Attr var int16A: Int16
    @Attr var int32A: Int32
    @Attr var int64A: Int64
    @Attr var uIntA: UInt
    @Attr var uInt8A: UInt8
    @Attr var uInt16A: UInt16
    @Attr var uInt32A: UInt32
    @Attr var uInt64A: UInt64
    @Attr var stringA: String
    
    var bool: Bool
    var int: Int
    var int8: Int8
    var int16: Int16
    var int32: Int32
    var int64: Int64
    var uInt: UInt
    var uInt8: UInt8
    var uInt16: UInt16
    var uInt32: UInt32
    var uInt64: UInt64
    var string: String
}

// MARK: ---

let s_bool : Bool = true
let s_int : Int = 1
let s_intOption : Int = 2
let s_str : String = "asd"
let s_strOption : String = "qwe"
let s_date : Date = Date()
let s_dateOption : Date = Date().addingTimeInterval(10)
var s_customDateFormatter : DateFormatter {
    let dft = DateFormatter()
    dft.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    return dft
}
var s_iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()
let s_data : Data = "asd".data(using: .utf8)!
let s_dataOption : Data = "qwe".data(using: .utf8)!
let s_floatNormal : Float = 1.1
let s_floatPositiveInfinity = "Positive Infinity"
let s_floatNegativeInfinity = "Negative Infinity"
let s_floatNan = "Nan"


let userXMLStrNarmal = """
<user>
    <id>\(s_int)</id>
    <alias>\(s_strOption)</alias>
    <name>\(s_str)</name>
    <age>\(s_intOption)</age>
</user>
"""

let userXMLStrNoOption = """
<user>
    <id>\(s_int)</id>
    <name>\(s_str)</name>
</user>
"""

let userAttrXMLStrNormal = """
<user id="\(s_int)" alias="\(s_strOption)" name="\(s_str)" age="\(s_intOption)">
</user>
"""

let userAttrXMLStrNoOption = """
<user id="\(s_int)" name="\(s_str)">
</user>
"""

let userPlaintextXMLStrNormal = """
<user id="\(s_int)" alias="\(s_strOption)">
\(s_str)
</user>
"""

let userPlaintextXMLStrNoOption = """
<user id="\(s_int)" alias="\(s_strOption)">
</user>
"""

let userBrothersXMLStrNormal = """
<user id="\(s_int)">
    <name>\(s_str)</name>
    <brothers id="\(s_int)" alias="\(s_strOption)">
        <name>\(s_str)</name>
        <age>\(s_intOption)</age>
    </brothers>
    <brothers id="\(s_int)" alias="\(s_strOption)">
        <name>\(s_str)</name>
        <age>\(s_intOption)</age>
    </brothers>
</user>
"""

let userBrothersXMLStrNoOption = """
<user id="\(s_int)">
    <name>\(s_str)</name>
</user>
"""

let userMixXMLStrNormal = """
<user id="\(s_int)" alias="\(s_strOption)">
    <name>\(s_str)</name>
    <age>\(s_intOption)</age>
</user>
"""

let userMixXMLStrNoOption = """
<user id="\(s_int)">
    <name>\(s_str)</name>
</user>
"""

let bookXMLStrNormal = """
<book id="\(s_int)">
    <name>\(s_str)</name>
    <owner id="\(s_int)" alias="\(s_strOption)">
        <name>\(s_str)</name>
        <age>\(s_intOption)</age>
    </owner>
</book>
"""

let bookXMLStrAllAttr = """
<book id="\(s_int)">
    <name>\(s_str)</name>
    <owner id="\(s_int)" name="\(s_str)">
    </owner>
</book>
"""

let bookXMLStrNoOption = """
<book id="\(s_int)">
    <name>\(s_str)</name>
    <owner id="\(s_int)">
        <name>\(s_str)</name>
    </owner>
</book>
"""

let bookXMLStrNoOwner = """
<book id="\(s_int)">
    <name>\(s_str)</name>
</book>
"""

let userBookXMLStrNormal = """
<user id="\(s_int)">
    <name>\(s_str)</name>
    <books>
        <book id="\(s_int)">
            <name>\(s_str)</name>
            <owner id="\(s_int)">
                <name>\(s_str)</name>
            </owner>
        </book>
        <book id="\(s_int)">
            <name>\(s_str)</name>
            <owner id="\(s_int)" alias="\(s_strOption)">
                <name>\(s_str)</name>
                <age>\(s_intOption)</age>
            </owner>
        </book>
    </books>
</user>
"""

let userBookXMLStrDic = """
<user id="\(s_int)">
    <name>\(s_str)</name>
    <books>
        <book1 id="\(s_int)">
            <name>\(s_str)</name>
            <owner id="\(s_int)">
                <name>\(s_str)</name>
            </owner>
        </book1>
        <book2 id="\(s_int)">
            <name>\(s_str)</name>
            <owner id="\(s_int)" alias="\(s_strOption)">
                <name>\(s_str)</name>
                <age>\(s_intOption)</age>
            </owner>
        </book2>
    </books>
</user>
"""

let userBookXMLStrAllAttr = """
<user id="\(s_int)">
    <name>\(s_str)</name>
    <books>
        <book id="\(s_int)" alias="\(s_strOption)">
        </book>
        <book id="\(s_int)">
        </book>
    </books>
</user>
"""

let squareXMLStr = """
<square id="\(s_int)" size="\(s_int)">
    <name>\(s_str)</name>
    <commonName>\(s_strOption)</commonName>
</square>
"""

// MARK: - Strategy

let dateXMLStrSince1970 = """
<date createTime="\(s_date.timeIntervalSince1970)" updateTime="\(s_dateOption.timeIntervalSince1970)">
    <createDate>\(s_date.timeIntervalSince1970)</createDate>
    <updateDate>\(s_dateOption.timeIntervalSince1970)</updateDate>
</date>
"""

let dateXMLStrSince1970NoOption = """
<date createTime="\(s_date.timeIntervalSince1970)">
    <createDate>\(s_date.timeIntervalSince1970)</createDate>
</date>
"""

let dateXMLStrMilliSince1970 = """
<date createTime="\(s_date.timeIntervalSince1970 * 1000)" updateTime="\(s_dateOption.timeIntervalSince1970 * 1000)">
    <createDate>\(s_date.timeIntervalSince1970 * 1000)</createDate>
    <updateDate>\(s_dateOption.timeIntervalSince1970 * 1000)</updateDate>
</date>
"""

let dateXMLStrIso8601 = """
<date createTime="\(s_iso8601Formatter.string(from: s_date))" updateTime="\(s_iso8601Formatter.string(from: s_dateOption))">
    <createDate>\(s_iso8601Formatter.string(from: s_date))</createDate>
    <updateDate>\(s_iso8601Formatter.string(from: s_dateOption))</updateDate>
</date>
"""

let dateXMLStrFormatted = """
<date createTime="\(s_customDateFormatter.string(from: s_date))" updateTime="\(s_customDateFormatter.string(from: s_dateOption))">
    <createDate>\(s_customDateFormatter.string(from: s_date))</createDate>
    <updateDate>\(s_customDateFormatter.string(from: s_dateOption))</updateDate>
</date>
"""

let dateXMLStrFormattedNoOption = """
<date createTime="\(s_customDateFormatter.string(from: s_date))">
    <createDate>\(s_customDateFormatter.string(from: s_date))</createDate>
</date>
"""

let dataXMLStrBase64 = """
<data dataAttr="\(s_data.base64EncodedString())" dataAttrOption="\(s_dataOption.base64EncodedString())">
    <data>\(s_data.base64EncodedString())</data>
    <dataOption>\(s_dataOption.base64EncodedString())</dataOption>
</data>
"""

let floatXML = """
<float floatAttr="\(s_floatPositiveInfinity)" floatAttrOption="\(s_floatNegativeInfinity)">
    <float>\(s_floatNan)</float>
    <floatOption>\(s_floatNormal)</floatOption>
</float>
"""

// MARK: - Key

let elementXMLFirstUppercase = """
<element>
    <ElementName>\(s_int)</ElementName>
    <ElementNameOption>\(s_intOption)</ElementNameOption>
</element>
"""

let elementXMLSnakeCase = """
<element>
    <element_name>\(s_int)</element_name>
    <element_name_option>\(s_intOption)</element_name_option>
</element>
"""

let attrXMLFirstUppercase = """
<attr AttrName="\(s_str)" AttrNameOption="\(s_strOption)">
</attr>
"""

let attrXMLSnakeCase = """
<attr attr_name="\(s_str)" attr_name_option="\(s_strOption)">
</attr>
"""

// MARK: - Cover More

let allCoverXML = """
<item boolA="\(s_bool)" intA="\(s_int)" int8A="\(s_int)" int16A="\(s_int)" int32A="\(s_int)" int64A="\(s_int)" uIntA="\(s_int)" uInt8A="\(s_int)" uInt16A="\(s_int)" uInt32A="\(s_int)" uInt64A="\(s_int)" stringA="\(s_str)">
    <bool>\(s_bool)</bool>
    <int>\(s_int)</int>
    <int8>\(s_int)</int8>
    <int16>\(s_int)</int16>
    <int32>\(s_int)</int32>
    <int64>\(s_int)</int64>
    <uInt>\(s_int)</uInt>
    <uInt8>\(s_int)</uInt8>
    <uInt16>\(s_int)</uInt16>
    <uInt32>\(s_int)</uInt32>
    <uInt64>\(s_int)</uInt64>
    <string>\(s_str)</string>
</item>
"""


// MARK: -
let userXMLStr = """
<user id="\(s_int)" alias="\(s_strOption)">
    <name>\(s_str)</name>
    <age>\(s_intOption)</age>
</user>
"""

let userStr = """
{
    "id" : \(s_int),
    "alias" : "\(s_strOption)",
    "name" : "\(s_str)",
    "age" : \(s_intOption),
}
"""
