//
//  XMLEncoderStrategyTests.swift
//  
//
//  Created by 黄磊 on 2020-03-23.
//

import XCTest
import MJXMLKit

final class XMLEncoderStrategyTests: XCTestCase {
    
    
    // MARK: - Data
    
    func testDateSecondsSince1970() throws {
        
        let data = dateXMLStrSince1970.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertEqual(date.updateTime!.description, s_dateOption.description)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertEqual(date.updateDate!.description, s_dateOption.description)
        
    }
    
    func testDateSecondsSince1970NoOption() throws {
        
        let data = dateXMLStrSince1970NoOption.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertNil(date.updateTime)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertNil(date.updateDate)
        
    }
    
    func testDateMilliSecondsSince1970() throws {
        
        let data = dateXMLStrMilliSince1970.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertEqual(date.updateTime!.description, s_dateOption.description)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertEqual(date.updateDate!.description, s_dateOption.description)
        
    }
    
    func testDateIso8601() throws {
        
        let data = dateXMLStrIso8601.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertEqual(date.updateTime!.description, s_dateOption.description)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertEqual(date.updateDate!.description, s_dateOption.description)
        
    }
    
    func testDateFormatted() throws {
        
        let data = dateXMLStrFormatted.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .formatted(s_customDateFormatter)
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .formatted(s_customDateFormatter)
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertEqual(date.updateTime!.description, s_dateOption.description)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertEqual(date.updateDate!.description, s_dateOption.description)
        
    }
    
    func testDateCustom() throws {
        
        let data = dateXMLStrFormatted.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let date = s_customDateFormatter.date(from: str) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Decoder date failed")
        })
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .custom({ (data, encoder) in
            var container = encoder.singleValueContainer()
            let str = s_customDateFormatter.string(from: data)
            try container.encode(str)
        })
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertEqual(date.updateTime!.description, s_dateOption.description)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertEqual(date.updateDate!.description, s_dateOption.description)
        
    }
    
    func testDateCustomNoOption() throws {
        
        let data = dateXMLStrFormattedNoOption.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let date = s_customDateFormatter.date(from: str) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Decoder date failed")
        })
        let tmpDate = try decoder.decode(DateStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .custom({ (data, encoder) in
            var container = encoder.singleValueContainer()
            let str = s_customDateFormatter.string(from: data)
            try container.encode(str)
        })
        let newData = try encoder.encode(tmpDate, withRootKey: "date")
        let date = try decoder.decode(DateStrategy.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(date.createTime.description, s_date.description)
        XCTAssertNil(date.updateTime)
        XCTAssertEqual(date.createDate.description, s_date.description)
        XCTAssertNil(date.updateDate)
        
    }
    
    // MARK: - Data
    
    func testDataBase64() throws {
        
        let data = dataXMLStrBase64.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dataDecodingStrategy = .base64
        let tmpData = try decoder.decode(DataStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dataEncodingStrategy = .base64
        let newData = try encoder.encode(tmpData, withRootKey: "data")
        let theData = try decoder.decode(DataStrategy.self, from: newData)
        
        XCTAssertEqual(theData.dataAttr, s_data)
        XCTAssertEqual(theData.dataAttrOption!, s_dataOption)
        XCTAssertEqual(theData.data, s_data)
        XCTAssertEqual(theData.dataOption!, s_dataOption)
        
    }
    
    func testDataCustom() throws {
        
        let data = dataXMLStrBase64.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.dataDecodingStrategy = .custom({ (decoder) -> Data in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let data = str.data(using: .utf8) {
                return data
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Decoder date failed")
        })
        let tmpData = try decoder.decode(DataStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.dataEncodingStrategy = .custom({ (data, encoder) in
            var container = encoder.singleValueContainer()
            let str = String(data: data, encoding: .utf8)
            try container.encode(str)
        })
        let newData = try encoder.encode(tmpData, withRootKey: "data")
        let theData = try decoder.decode(DataStrategy.self, from: newData)
        
        XCTAssertEqual(theData.dataAttr, s_data.base64EncodedString().data(using: .utf8))
        XCTAssertEqual(theData.dataAttrOption!, s_dataOption.base64EncodedString().data(using: .utf8))
        XCTAssertEqual(theData.data, s_data.base64EncodedString().data(using: .utf8))
        XCTAssertEqual(theData.dataOption!, s_dataOption.base64EncodedString().data(using: .utf8))
        
    }
    
    // MARK: - Float
    
    func testFloatConvert() throws {
        
        let data = floatXML.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: s_floatPositiveInfinity, negativeInfinity: s_floatNegativeInfinity, nan: s_floatNan)
        let tmpData = try decoder.decode(FloatStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: s_floatPositiveInfinity, negativeInfinity: s_floatNegativeInfinity, nan: s_floatNan)
        let newData = try encoder.encode(tmpData, withRootKey: "float")
        let theFloat = try decoder.decode(FloatStrategy.self, from: newData)
        
        XCTAssertEqual(theFloat.floatAttr, Float.infinity)
        XCTAssertEqual(theFloat.floatAttrOption!, -Float.infinity)
        XCTAssertTrue(theFloat.float.isNaN)
        // 这里存在误差，无法直接对比
        XCTAssertEqual(theFloat.floatOption!, s_floatNormal)
        
    }
    
    func testDoubleConvert() throws {
        
        let data = floatXML.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: s_floatPositiveInfinity, negativeInfinity: s_floatNegativeInfinity, nan: s_floatNan)
        let tmpData = try decoder.decode(DoubleStrategy.self, from: data)
        let encoder = XMLEncoder()
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: s_floatPositiveInfinity, negativeInfinity: s_floatNegativeInfinity, nan: s_floatNan)
        let newData = try encoder.encode(tmpData, withRootKey: "float")
        let theFloat = try decoder.decode(DoubleStrategy.self, from: newData)
        
        
        XCTAssertEqual(theFloat.floatAttr, Double.infinity)
        XCTAssertEqual(theFloat.floatAttrOption!, -Double.infinity)
        XCTAssertTrue(theFloat.float.isNaN)
        // 这里存在误差，无法直接对比
        XCTAssertTrue(abs(theFloat.floatOption! - Double(s_floatNormal)) < 0.001)
        
    }
    
    // MARK: - Key
    
    func testElementNameFirstUppercase() throws {
        
        let data = elementXMLFirstUppercase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.elementNameDecodingStrategy = .lowercaseFirstLetter
        let tmpData = try decoder.decode(ElementName.self, from: data)
        let encoder = XMLEncoder()
        encoder.elementNameEncodingStrategy = .uppercaseFirstLetter
        let newData = try encoder.encode(tmpData, withRootKey: "element")
        let element = try decoder.decode(ElementName.self, from: newData)
        
        XCTAssertEqual(element.elementName, s_int)
        XCTAssertEqual(element.elementNameOption!, s_intOption)
        
    }
    
    func testElementNameSnakeCase() throws {
        
        let data = elementXMLSnakeCase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.elementNameDecodingStrategy = .convertFromSnakeCase
        let tmpData = try decoder.decode(ElementName.self, from: data)
        let encoder = XMLEncoder()
        encoder.elementNameEncodingStrategy = .convertToSnakeCase
        let newData = try encoder.encode(tmpData, withRootKey: "element")
        let element = try decoder.decode(ElementName.self, from: newData)
        
        XCTAssertEqual(element.elementName, s_int)
        XCTAssertEqual(element.elementNameOption!, s_intOption)
        
    }
    
    func testElementNameCustom() throws {
        
        let dic = [
            "element_name" : "elementName",
            "element_name_option" : "elementNameOption"
        ]
        
        let dicRevert = [
            "elementName" : "element_name",
            "elementNameOption" : "element_name_option"
        ]
        
        let data = elementXMLSnakeCase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.elementNameDecodingStrategy = .custom({ (keys) -> CodingKey in
            let lastKey = keys.last!.stringValue
            return XMLKey(stringValue: dic[lastKey] ?? "")!
        })
        let tmpData = try decoder.decode(ElementName.self, from: data)
        let encoder = XMLEncoder()
        encoder.elementNameEncodingStrategy = .custom({ (keys) -> CodingKey in
            let lastKey = keys.last!.stringValue
            return XMLKey(stringValue: dicRevert[lastKey] ?? "")!
        })
        let newData = try encoder.encode(tmpData, withRootKey: "element")
        let element = try decoder.decode(ElementName.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(element.elementName, s_int)
        XCTAssertEqual(element.elementNameOption!, s_intOption)
        
    }
    
    func testAttrNameFirstUppercase() throws {
        
        let data = attrXMLFirstUppercase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.attrNameDecodingStrategy = .lowercaseFirstLetter
        let tmpData = try decoder.decode(AttrName.self, from: data)
        let encoder = XMLEncoder()
        encoder.attrNameEncodingStrategy = .uppercaseFirstLetter
        let newData = try encoder.encode(tmpData, withRootKey: "attr")
        let attr = try decoder.decode(AttrName.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(attr.attrName, s_str)
        XCTAssertEqual(attr.attrNameOption!, s_strOption)
        
    }
    
    func testAttrNameSnakeCase() throws {
        
        let data = attrXMLSnakeCase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.attrNameDecodingStrategy = .convertFromSnakeCase
        let tmpData = try decoder.decode(AttrName.self, from: data)
        let encoder = XMLEncoder()
        encoder.attrNameEncodingStrategy = .convertToSnakeCase
        let newData = try encoder.encode(tmpData, withRootKey: "attr")
        let attr = try decoder.decode(AttrName.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(attr.attrName, s_str)
        XCTAssertEqual(attr.attrNameOption!, s_strOption)
        
    }
    
    func testAttrNameCustom() throws {
        do {
        let dic = [
            "attr_name" : "attrName",
            "attr_name_option" : "attrNameOption"
        ]
        
        let dicRevert = [
            "attrName" : "attr_name",
            "attrNameOption" : "attr_name_option"
        ]
        
        let data = attrXMLSnakeCase.data(using: .utf8)!
        
        let decoder = XMLDecoder()
        decoder.attrNameDecodingStrategy = .custom({ (keys) -> CodingKey in
            let lastKey = keys.last!.stringValue
            return XMLKey(stringValue: dic[lastKey] ?? "")!
        })
        let tmpData = try decoder.decode(AttrName.self, from: data)
        let encoder = XMLEncoder()
        encoder.attrNameEncodingStrategy = .custom({ (keys) -> CodingKey in
            let lastKey = keys.last!.stringValue
            return XMLKey(stringValue: dicRevert[lastKey] ?? "")!
        })
        let newData = try encoder.encode(tmpData, withRootKey: "attr")
        let attr = try decoder.decode(AttrName.self, from: newData)
        
        // 这里存在误差，无法直接对比
        XCTAssertEqual(attr.attrName, s_str)
        XCTAssertEqual(attr.attrNameOption!, s_strOption)
        } catch {
            print(error)
        }
    }
    
}
