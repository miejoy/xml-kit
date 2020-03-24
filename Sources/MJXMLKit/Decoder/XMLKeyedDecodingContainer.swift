//
//  _XMLKeyedDecodingContainer.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation


internal struct _XMLKeyedDecodingContainer<K : CodingKey> : KeyedDecodingContainerProtocol  {
    
    typealias Key = K
        
    private let decoder: _XMLDecoder
    private let element : _XMLElement
    private let container: [String : _XMLElement]
    
    var codingPath: [CodingKey]
    
    init(decoder: _XMLDecoder, element: _XMLElement) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        // 处理属性
        var dicAttrs = [String:String]()
        for attr in element.attributes {
            let aKey = decoder.options.attrNameDecodingStrategy.convertFrom(attr.key, path: (self.codingPath + [_XMLKey(stringValue: attr.key)!]))
            dicAttrs[aKey] = attr.value
        }
        element.attributes = dicAttrs
        self.element = element
        // 读取 container
        var container = [String:_XMLElement]()
        for element in element.children {
            let aName = decoder.options.elementNameDecodingStrategy
                .convertFrom(element.name, path: (self.codingPath + [_XMLKey(stringValue: element.name)!]))
            container[aName] = element
        }
        self.container = container
    }
    
    var allKeys: [K] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    func contains(_ key: K) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        if let element = self.container[key.stringValue] {
            return element.value == nil && element.children.isEmpty && element.attributes.isEmpty
        }

        return true
    }
    
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: String.Type, forKey key: K) throws -> String {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        if let attrType = type as? AnyAttr.Type {
            return try self.decode(attrType, forKey: key) as! T
        }
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.decoder.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(element, as: type) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath, with: type)
        }
        return value
    }
    
    func decode(_ type: AnyAttr.Type, forKey key: K) throws -> AnyAttr {
        
        let value = element.attributes[key.stringValue]
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let decoder = _XMLAttrDecoder(key: key.stringValue, content: value, decoder: self.decoder)
        let attr = type.init()
        try attr.decode(from: decoder)
        return attr
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy, prevDesc: "Cannot get \(KeyedDecodingContainer<NestedKey>.self)")
        }

        let container = _XMLKeyedDecodingContainer<NestedKey>(decoder: self.decoder, element: element)
        return KeyedDecodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let element = self.container[key.stringValue] else {
            throw DecodingError._keyNotFound(at: self.codingPath, with: key, strategy: self.decoder.options.elementNameDecodingStrategy, prevDesc: "Cannot get UnkeyedDecodingContainer")
        }

        return _XMLUnkeyedDecodingContainer(decoder: self.decoder, elements: element.children)
    }
    
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: _XMLKey.super)
    }

    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
    
    private func _superDecoder(forKey key: __owned CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }

        let element : _XMLElement = self.container[key.stringValue] ?? self.decoder.topElement
        return _XMLDecoder(rootElement: element, at: self.decoder.codingPath, options: self.decoder.options)
    }
    
    
}
