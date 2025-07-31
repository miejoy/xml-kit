//
//  _XMLUnkeyedEncodingContainer.swift
//
//
//  Created by 黄磊 on 2020-03-23.
//

import Foundation

internal struct _XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    // MARK: Properties

    /// A reference to the encoder we're writing to.
    private let encoder: _XMLEncoder

    /// A reference to the container we're writing to.
    private let container: _XMLElement

    /// The path of coding keys taken to get to this point in encoding.
    private(set) var codingPath: [CodingKey]

    /// The number of elements encoded into the container.
    var count: Int {
        return self.container.children.count
    }
    
    func currentKey(type: Any.Type) -> String {
        return self.encoder.options.arrayIndexKeyStrategy.getKey(from: count, type: type)
    }

    // MARK: - Initialization

    /// Initializes `self` with the given element.
    init(encoder: _XMLEncoder, element: _XMLElement) {
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.container = element
    }

    // MARK: - UnkeyedEncodingContainer Methods

    mutating func encodeNil()             throws { self.container.children.append(_XMLElement(name: currentKey(type: Any.self))) }
    mutating func encode(_ value: Bool)   throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: Int)    throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: Int8)   throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: Int16)  throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: Int32)  throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: Int64)  throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: UInt)   throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: UInt8)  throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: UInt16) throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: UInt32) throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: UInt64) throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }
    mutating func encode(_ value: String) throws { self.container.children.append(encoder.box(value, with: currentKey(type: type(of: value)))) }

    mutating func encode(_ value: Float)  throws {
        // Since the float may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(_XMLKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        self.container.children.append(try encoder.box(value, with: count.description))
    }

    mutating func encode(_ value: Double) throws {
        // Since the double may be invalid and throw, the coding path needs to contain this key.
        self.encoder.codingPath.append(_XMLKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        self.container.children.append(try encoder.box(value, with: currentKey(type: type(of: value))))
    }

    mutating func encode<T: Encodable>(_ value: T) throws {
        self.encoder.codingPath.append(_XMLKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        self.container.children.append(try encoder.box(value, with: currentKey(type: type(of: value))))
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        // 没有想清楚什么时候会调到这
        self.codingPath.append(_XMLKey(index: self.count))
        defer { self.codingPath.removeLast() }

        let newElement = _XMLElement(name: currentKey(type: type(of: Any.self)))
        self.container.children.append(newElement)

        let container = _XMLKeyedEncodingContainer<NestedKey>(encoder: self.encoder, element: newElement)
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        self.codingPath.append(_XMLKey(index: self.count))
        defer { self.codingPath.removeLast() }

        let newElement = _XMLElement(name: currentKey(type: Any.self))
        self.container.children.append(newElement)
        
        return _XMLUnkeyedEncodingContainer(encoder: self.encoder, element: newElement)
    }

    mutating func superEncoder() -> Encoder {
        self.encoder.codingPath.append(_XMLKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        
        return _XMLEncoder(options: self.encoder.options, with: currentKey(type: type(of: Any.self)), codingPath: self.encoder.codingPath)
    }
}
