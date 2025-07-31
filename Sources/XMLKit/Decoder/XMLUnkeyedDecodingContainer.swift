//
//  _XMLUnkeyedDecodingContainer.swift
//
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation

internal struct _XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    private let decoder: _XMLDecoder
    private let container: [_XMLElement]
    
    private(set) var currentIndex: Int

    var codingPath: [CodingKey]

    init(decoder: _XMLDecoder, elements: [_XMLElement]) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        self.container = elements
        self.currentIndex = 0
    }
    
    var count: Int? {
        return self.container.count
    }
    
    var isAtEnd: Bool {
        return self.currentIndex >= self.count!
    }
        
    mutating func decodeNil() throws -> Bool {
        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(Any?.self, DecodingError.Context(
                codingPath: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)],
                debugDescription: "Unkeyed container is at end."))
        }
        
        let element = self.container[self.currentIndex]
        if element.value == nil && element.attributes.isEmpty && element.children.isEmpty {
            self.currentIndex += 1
            return true
        }
        return false
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Bool.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: String.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Double.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Float.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int8.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int16.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int32.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Int64.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt8.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt16.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt32.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: UInt64.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard !self.isAtEnd else {
            throw DecodingError._valueNotFoundReachEnd(at: self.decoder.codingPath, with: type, index: self.currentIndex)
        }

        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: T.self) else {
            throw DecodingError._valueNotFound(at: self.decoder.codingPath + [_XMLKey(index: self.currentIndex)], with: type)
        }

        self.currentIndex += 1
        return decoded
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."))
        }

        let element = self.container[self.currentIndex]

        self.currentIndex += 1
        let container = _XMLKeyedDecodingContainer<NestedKey>(decoder: self.decoder, element: element)
        
        return KeyedDecodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot get nested unkeyed container -- unkeyed container is at end."))
        }

        let element = self.container[self.currentIndex]

        self.currentIndex += 1
        
        return _XMLUnkeyedDecodingContainer(decoder: self.decoder, elements: element.children)
    }
    
    mutating func superDecoder() throws -> Decoder {
        self.decoder.codingPath.append(_XMLKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        guard !self.isAtEnd else {
            throw DecodingError.valueNotFound(Decoder.self,
                                              DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."))
        }

        let element = self.container[self.currentIndex]
        self.currentIndex += 1
        return _XMLDecoder(rootElement: element, at: self.decoder.codingPath, options: self.decoder.options)
    }
}
