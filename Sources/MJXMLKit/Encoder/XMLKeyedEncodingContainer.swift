//
//  _XMLKeyedEncodingContainer.swift
//  
//
//  Created by 黄磊 on 2020-03-23.
//

import Foundation

internal struct _XMLKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K

    // MARK: Properties

    /// A reference to the encoder we're writing to.
    private let encoder: _XMLEncoder

    /// A reference to the container we're writing to.
    private let container: _XMLElement

    /// The path of coding keys taken to get to this point in encoding.
    private(set) var codingPath: [CodingKey]

    // MARK: - Initialization

    /// Initializes `self` with the given element.
    init(encoder: _XMLEncoder, element: _XMLElement) {
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.container = element
    }

    // MARK: - Coding Path Operations

    private func _converted(_ key: CodingKey) -> CodingKey {
        switch encoder.options.elementNameEncodingStrategy {
        case .useDefaultKeys:
            return key
        case .uppercaseFirstLetter:
            let newKeyString = XMLEncoder.KeyEncodingStrategy._uppercaseFirstLetter(key.stringValue)
            return _XMLKey(stringValue: newKeyString, intValue: key.intValue)
        case .convertToSnakeCase:
            let newKeyString = XMLEncoder.KeyEncodingStrategy._convertToSnakeCase(key.stringValue)
            return _XMLKey(stringValue: newKeyString, intValue: key.intValue)
        case .custom(let converter):
            return converter(codingPath + [key])
        }
    }
    
    // MARK: - KeyedEncodingContainerProtocol Methods

    mutating func encodeNil(forKey key: Key) throws {
        self.container.children.append(_XMLElement(name: _converted(key).stringValue))
    }
    mutating func encode(_ value: Bool, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: Int, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: Int8, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: Int16, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: Int32, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: Int64, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: UInt, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    mutating func encode(_ value: String, forKey key: Key) throws {
        self.container.children.append(self.encoder.box(value, with: _converted(key).stringValue))
    }
    
    mutating func encode(_ value: Float, forKey key: Key) throws {
        // Since the float may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container.children.append(try self.encoder.box(value, with: _converted(key).stringValue))
    }

    mutating func encode(_ value: Double, forKey key: Key) throws {
        // Since the double may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.container.children.append(try self.encoder.box(value, with: _converted(key).stringValue))
    }

    mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        
        if value is AnyAttr {
            self.encoder.codingPath.append(key)
            defer { self.encoder.codingPath.removeLast() }
            
            let newKey = self.encoder.options.attrNameEncodingStrategy.convertFrom(key.stringValue, path: self.encoder.codingPath)
            
            let aEncoder = _XMLAttrEncoder(key: newKey, element: container, encoder: encoder)
            try value.encode(to: aEncoder)
            return
        } else if value is AnyPlaintext {
            self.encoder.codingPath.append(key)
            defer { self.encoder.codingPath.removeLast() }
            
            try value.encode(to: encoder)
            return
        }
        
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        
        let element = try self.encoder.box(value, with: _converted(key).stringValue)
        if value is AnyBrothers {
            let strKey = _converted(key).stringValue
            let children = element.children.map { (element) -> _XMLElement in
                element.name = strKey
                return element
            }
            self.container.children.append(contentsOf: children)
        } else {
            self.container.children.append(try self.encoder.box(value, with: _converted(key).stringValue))
        }
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let containerKey = _converted(key).stringValue
        // 这里新元素作为当前元素的孩子接点，不需要再保存到 storage 里
        let newElement = _XMLElement(name: containerKey)
        self.container.children.append(newElement)


        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }

        let container = _XMLKeyedEncodingContainer<NestedKey>(encoder: self.encoder, element: newElement)

        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let containerKey = _converted(key).stringValue
        let newElement = _XMLElement(name: containerKey)
        self.container.children.append(newElement)
        
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        
        return _XMLUnkeyedEncodingContainer(encoder: self.encoder, element: newElement)

    }

    /// 一般是类自己编码的时候使用
    mutating func superEncoder() -> Encoder {
        return _superEncoder(forKey: _XMLKey.super)
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
        return _superEncoder(forKey: key)
    }
    
    private func _superEncoder(forKey key: __owned CodingKey) -> Encoder {
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }

        let newEncoder = _XMLEncoder(options: self.encoder.options, with: key.stringValue, codingPath: self.encoder.codingPath)
        newEncoder.storage.push(element: self.encoder.topElement)
        return newEncoder
    }
}
