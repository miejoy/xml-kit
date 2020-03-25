//
//  XMLDecoder.swift
//
//
//  Created by 黄磊 on 2020-03-21.
//

import Foundation
import Combine

/// XML 解码器
open class XMLDecoder {
    
    // MARK: Options

    /// The strategy to use for decoding `Date` values.
    public enum DateDecodingStrategy {
        /// Defer to `Date` for decoding. This is the default strategy.
        case deferredToDate

        /// Decode the `Date` as a UNIX timestamp from a JSON number.
        case secondsSince1970

        /// Decode the `Date` as UNIX millisecond timestamp from a JSON number.
        case millisecondsSince1970

        /// Decode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
        case iso8601

        /// Decode the `Date` as a string parsed by the given formatter.
        case formatted(DateFormatter)

        /// Decode the `Date` as a custom value decoded by the given closure.
        case custom((_ decoder: Decoder) throws -> Date)
    }

    /// The strategy to use for decoding `Data` values.
    public enum DataDecodingStrategy {
        /// Defer to `Data` for decoding.
        case deferredToData

        /// Decode the `Data` from a Base64-encoded string. This is the default strategy.
        case base64

        /// Decode the `Data` as a custom value decoded by the given closure.
        case custom((_ decoder: Decoder) throws -> Data)
    }

    /// The strategy to use for non-JSON-conforming floating-point values (IEEE 754 infinity and NaN).
    public enum NonConformingFloatDecodingStrategy {
        /// Throw upon encountering non-conforming values. This is the default strategy.
        case `throw`

        /// Decode the values from the given representation strings.
        case convertFromString(positiveInfinity: String, negativeInfinity: String, nan: String)
    }

    /// The strategy to use for automatically changing the value of keys before decoding.
    public enum KeyDecodingStrategy {
        /// Use the keys specified by each type. This is the default strategy.
        case useDefaultKeys
        
        case convertFromSnakeCase
        
        case lowercaseFirstLetter
        
        case custom((_ codingPath: [CodingKey]) -> CodingKey)
        
        internal func convertFrom(_ stringKey: String, path: [CodingKey]) -> String {
            switch self {
            case .useDefaultKeys:
                return stringKey
            case .convertFromSnakeCase:
                return Self._convertFromSnakeCase(stringKey)
            case .lowercaseFirstLetter:
                return Self._lowercaseFirstLetter(stringKey)
            case let .custom(closure):
                return closure(path).stringValue
            }
        }
        
        internal static func _lowercaseFirstLetter(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
            
            return stringKey.first!.lowercased() + stringKey.dropFirst()
            
        }
        
        internal static func _convertFromSnakeCase(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
        
            // Find the first non-underscore character
            guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
                // Reached the end without finding an _
                return stringKey
            }
        
            // Find the last non-underscore character
            var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
            while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
                stringKey.formIndex(before: &lastNonUnderscore)
            }
        
            let keyRange = firstNonUnderscore...lastNonUnderscore
            let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
            let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
        
            let components = stringKey[keyRange].split(separator: "_")
            let joinedString : String
            if components.count == 1 {
                // No underscores in key, leave the word as is - maybe already camel cased
                joinedString = String(stringKey[keyRange])
            } else {
                joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
            }
        
            // Do a cheap isEmpty check before creating and appending potentially empty strings
            let result : String
            if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
                result = joinedString
            } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
                // Both leading and trailing underscores
                result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
            } else if (!leadingUnderscoreRange.isEmpty) {
                // Just leading
                result = String(stringKey[leadingUnderscoreRange]) + joinedString
            } else {
                // Just trailing
                result = joinedString + String(stringKey[trailingUnderscoreRange])
            }
            return result
        }
    }
    
    
    /// The strategy to use in decoding dates. Defaults to `.deferredToDate`.
    open var dateDecodingStrategy: DateDecodingStrategy = .deferredToDate

    /// The strategy to use in decoding binary data. Defaults to `.base64`.
    open var dataDecodingStrategy: DataDecodingStrategy = .base64

    /// The strategy to use in decoding non-conforming numbers. Defaults to `.throw`.
    open var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw

    /// The strategy to use for decoding element name. Defaults to `.useDefaultKeys`.
    open var elementNameDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys
    
    /// The strategy to use for decoding attr name. Defaults to `.useDefaultKeys`.
    open var attrNameDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys
    
    /// Contextual user-provided information for use during decoding.
    open var userInfo: [CodingUserInfoKey : Any] = [:]

    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    internal struct _Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let elementNameDecodingStrategy: KeyDecodingStrategy
        let attrNameDecodingStrategy: KeyDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }

    /// The options set on the top-level decoder.
    internal var options: _Options {
        return _Options(dateDecodingStrategy: dateDecodingStrategy,
                        dataDecodingStrategy: dataDecodingStrategy,
                        nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                        elementNameDecodingStrategy: elementNameDecodingStrategy,
                        attrNameDecodingStrategy: attrNameDecodingStrategy,
                        userInfo: userInfo)
    }

    // MARK: - Constructing a XML Decoder

    /// Initializes `self` with default strategies.
    public init() {}

    // MARK: - Decoding Values

    open func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T {

        let rootElement: _XMLElement
        do {
           rootElement = try _XMLParser.parse(with: data)
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid XML.", underlyingError: error))
        }

        let decoder = _XMLDecoder(rootElement: rootElement, at: [], options: self.options)

        return try T.init(from: decoder)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension XMLDecoder : TopLevelDecoder {

    public typealias Input = Data
}

// MARK: - _XMLDecoder

/// 实际使用的 XML 解码器
internal class _XMLDecoder : Decoder {
    
    
    // MARK: Properties

    let rootElement : _XMLElement
    
    var storage : _XMLDecodingStorage
    var decodeOnlyValue : Bool = false
    
    /// 最上层元素，这里指的是当前正在编码的原始
    var topElement : _XMLElement {
        return storage.topElement
    }

    /// Options set on the top-level decoder.
    let options: XMLDecoder._Options

    /// The path to the current point in encoding.
    internal(set) public var codingPath: [CodingKey]

    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return self.options.userInfo
    }

    // MARK: - Initialization

    /// Initializes `self` with the given top-level container and options.
    init(rootElement: _XMLElement, at codingPath: [CodingKey] = [], options: XMLDecoder._Options) {
        self.rootElement = rootElement
        self.codingPath = codingPath
        self.options = options
        self.storage = _XMLDecodingStorage()
        self.storage.push(element: rootElement)
    }

    // MARK: - Decoder Methods

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        
        let container = _XMLKeyedDecodingContainer<Key>.init(decoder: self, element: topElement)
        
        return KeyedDecodingContainer(container)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let container = _XMLUnkeyedDecodingContainer.init(decoder: self, elements: topElement.children)
        return container
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}


extension _XMLDecoder : SingleValueDecodingContainer {
    
    private func expectNonNil<T>(_ type: T.Type) throws {
        guard !self.decodeNil() else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
        }
    }
    
    func decodeNil() -> Bool {
        if decodeOnlyValue {
            return self.topElement.value == nil
        }
        return self.topElement.value == nil && self.topElement.attributes.isEmpty && self.topElement.children.isEmpty
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        try expectNonNil(Bool.self)
        return try self.unbox(topElement, as: Bool.self)!
    }
    
    func decode(_ type: String.Type) throws -> String {
        try expectNonNil(String.self)
        return try self.unbox(topElement, as: String.self)!
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        try expectNonNil(Double.self)
        return try self.unbox(topElement, as: Double.self)!
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        try expectNonNil(Float.self)
        return try self.unbox(topElement, as: Float.self)!
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        try expectNonNil(Int.self)
        return try self.unbox(topElement, as: Int.self)!
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNonNil(Int8.self)
        return try self.unbox(topElement, as: Int8.self)!
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNonNil(Int16.self)
        return try self.unbox(topElement, as: Int16.self)!
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNonNil(Int32.self)
        return try self.unbox(topElement, as: Int32.self)!
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNonNil(Int64.self)
        return try self.unbox(topElement, as: Int64.self)!
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        try expectNonNil(UInt.self)
        return try self.unbox(topElement, as: UInt.self)!
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNonNil(UInt8.self)
        return try self.unbox(topElement, as: UInt8.self)!
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNonNil(UInt16.self)
        return try self.unbox(topElement, as: UInt16.self)!
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNonNil(UInt32.self)
        return try self.unbox(topElement, as: UInt32.self)!
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNonNil(UInt64.self)
        return try self.unbox(topElement, as: UInt64.self)!
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try expectNonNil(T.self)
        return try self.unbox(topElement, as: T.self)!
    }
}
