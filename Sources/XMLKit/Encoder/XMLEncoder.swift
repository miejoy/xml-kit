//
//  XMLEncoder.swift
//
//
//  Created by 黄磊 on 2020-03-21.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

open class XMLEncoder {
    /// The formatting of the output XML data.
    public struct OutputFormatting: OptionSet {
        /// The format's default value.
        public let rawValue: UInt

        /// Creates an OutputFormatting value with the given raw value.
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// Produce human-readable XML with indented output.
        public static let prettyPrinted: XMLEncoder.OutputFormatting = XMLEncoder.OutputFormatting(rawValue: 1 << 0)
        
        public static let sortedAttrs: XMLEncoder.OutputFormatting = XMLEncoder.OutputFormatting(rawValue: 1 << 1)

        public typealias Element = XMLEncoder.OutputFormatting

        public typealias ArrayLiteralElement = XMLEncoder.OutputFormatting

        public typealias RawValue = UInt
    }

    /// The strategy to use for encoding `Date` values.
    public enum DateEncodingStrategy {
        /// Defer to `Date` for choosing an encoding. This is the default strategy.
        case deferredToDate

        /// Encode the `Date` as a UNIX timestamp (as a JSON number).
        case secondsSince1970

        /// Encode the `Date` as UNIX millisecond timestamp (as a JSON number).
        case millisecondsSince1970

        /// Encode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
        case iso8601

        /// Encode the `Date` as a string formatted by the given formatter.
        case formatted(DateFormatter)

        /// Encode the `Date` as a custom value encoded by the given closure.
        ///
        /// If the closure fails to encode a value into the given encoder, the encoder will encode an empty automatic container in its place.
        case custom((Date, Encoder) throws -> Void)
    }

    /// The strategy to use for encoding `Data` values.
    public enum DataEncodingStrategy {
        /// Defer to `Data` for choosing an encoding.
        case deferredToData

        /// Encoded the `Data` as a Base64-encoded string. This is the default strategy.
        case base64

        /// Encode the `Data` as a custom value encoded by the given closure.
        ///
        /// If the closure fails to encode a value into the given encoder, the encoder will encode an empty automatic container in its place.
        case custom((Data, Encoder) throws -> Void)
    }

    /// The strategy to use for non-JSON-conforming floating-point values (IEEE 754 infinity and NaN).
    public enum NonConformingFloatEncodingStrategy {
        /// Throw upon encountering non-conforming values. This is the default strategy.
        case `throw`

        /// Encode the values using the given representation strings.
        case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
    }

    /// The strategy to use for automatically changing the value of keys before encoding.
    public enum KeyEncodingStrategy {
        /// Use the keys specified by each type. This is the default strategy.
        case useDefaultKeys

        case convertToSnakeCase
        
        case uppercaseFirstLetter

        case custom(([CodingKey]) -> CodingKey)
        
        internal func convertFrom(_ stringKey: String, path: [CodingKey]) -> String {
            switch self {
            case .useDefaultKeys:
                return stringKey
            case .convertToSnakeCase:
                return Self._convertToSnakeCase(stringKey)
            case .uppercaseFirstLetter:
                return Self._uppercaseFirstLetter(stringKey)
            case let .custom(closure):
                return closure(path).stringValue
            }
        }
        
        internal static func _uppercaseFirstLetter(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
            
            return stringKey.first!.uppercased() + stringKey.dropFirst()
        }
        
        internal static func _convertToSnakeCase(_ stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }
        
            var words: [Range<String.Index>] = []
            // The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
            //
            // myProperty -> my_property
            // myURLProperty -> my_url_property
            //
            // We assume, per Swift naming conventions, that the first character of the key is lowercase.
            var wordStart = stringKey.startIndex
            var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex
        
            // Find next uppercase character
            while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
                let untilUpperCase = wordStart..<upperCaseRange.lowerBound
                words.append(untilUpperCase)
                
                // Find next lowercase character
                searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
                guard let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange) else {
                    // There are no more lower case letters. Just end here.
                    wordStart = searchRange.lowerBound
                    break
                }
                
                // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
                let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
                if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                    // The next character after capital is a lower case character and therefore not a word boundary.
                    // Continue searching for the next upper case for the boundary.
                    wordStart = upperCaseRange.lowerBound
                } else {
                    // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
                    let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
                    words.append(upperCaseRange.lowerBound..<beforeLowerIndex)
                    
                    // Next word starts at the capital before the lowercase we just found
                    wordStart = beforeLowerIndex
                }
                searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
            }
            words.append(wordStart..<searchRange.upperBound)
            let result = words.map({ (range) in
                return stringKey[range].lowercased()
            }).joined(separator: "_")
            return result
        }
    }
    
    /// 编码数组是，对应 index 标签名称
    public enum ArrayIndexKeyStrategy {
        /// 使用默认 Index 前缀
        case defaultIndexPrefix
        
        /// 使用类名
        case useTypeName
        
        /// 自定义前缀
        case customPrefix(String)
        
        func getKey(from index: Int, type: Any.Type) -> String {
            switch self {
            case .defaultIndexPrefix:
                return "Index\(index)"
            case .useTypeName:
                return String(reflecting: Self.self).components(separatedBy: ".").last ?? "Index\(index)"
            case let .customPrefix(prefix):
                return "\(prefix)\(index)"
            }
        }
    }

    /// The output format to produce. Defaults to `[]`.
    open var outputFormatting: OutputFormatting = []

    /// The strategy to use in encoding dates. Defaults to `.deferredToDate`.
    open var dateEncodingStrategy: DateEncodingStrategy = .deferredToDate

    /// The strategy to use in encoding binary data. Defaults to `.base64`.
    open var dataEncodingStrategy: DataEncodingStrategy = .base64

    /// The strategy to use in encoding non-conforming numbers. Defaults to `.throw`.
    open var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw

    /// The strategy to use for encoding element name. Defaults to `.useDefaultKeys`.
    open var elementNameEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys

    /// The strategy to use for encoding attr name. Defaults to `.useDefaultKeys`.
    open var attrNameEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys
    
    /// The strategy to use for encoding array index. Defaults to `.defaultIndexPrefix`.
    open var arrayIndexKeyStrategy: ArrayIndexKeyStrategy = .defaultIndexPrefix
    
    /// Contextual user-provided information for use during encoding.
    open var userInfo: [CodingUserInfoKey: Any] = [:]

    /// Initializes `self` with default strategies.
    public init() {
    }
    
    internal struct _Options {
        let outputFormatting: OutputFormatting
        let dateEncodingStrategy: DateEncodingStrategy
        let dataEncodingStrategy: DataEncodingStrategy
        let nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy
        let elementNameEncodingStrategy: KeyEncodingStrategy
        let attrNameEncodingStrategy: KeyEncodingStrategy
        let arrayIndexKeyStrategy: ArrayIndexKeyStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }

    /// The options set on the top-level encoder.
    internal var options: _Options {
        return _Options(outputFormatting: outputFormatting,
                        dateEncodingStrategy: dateEncodingStrategy,
                        dataEncodingStrategy: dataEncodingStrategy,
                        nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
                        elementNameEncodingStrategy: elementNameEncodingStrategy,
                        attrNameEncodingStrategy: attrNameEncodingStrategy,
                        arrayIndexKeyStrategy: arrayIndexKeyStrategy,
                        userInfo: userInfo)
    }

    /// Encodes the given top-level value and returns its XML representation.

    open func encode<T: Encodable>(_ value: T, withRootKey rootKey: String, header: XMLHeader? = nil) throws -> Data {
        let encoder = _XMLEncoder(options: self.options, with: rootKey)

        guard let topLevel = try encoder.box_(value, with: rootKey) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(
                codingPath: [],
                debugDescription: "Top-level \(T.self) did not encode any values."))
        }

        let string = topLevel.toXMLString(with: header,
                                          prettyPrinted: self.options.outputFormatting.contains(.prettyPrinted))
        
        return string.data(using: .utf8)!
    }
}

#if canImport(Combine)
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension XMLEncoder: TopLevelEncoder {
    public typealias Output = Data
    
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try encode(value, withRootKey: "Root", header: nil)
    }
}
#endif


// MARK: - _XMLEncoder

/// 实际使用 XML 编码器
internal class _XMLEncoder: Encoder {
    let options: XMLEncoder._Options
    
    var codingPath: [CodingKey]
    
    var storage: _XMLEncodingStorage
    
    var userInfo: [CodingUserInfoKey: Any]
    
    var topElement: _XMLElement {
        return storage.topElement
    }
    
    init(options: XMLEncoder._Options, with rootKey: String, codingPath: [CodingKey] = []) {
        self.options = options
        self.storage = _XMLEncodingStorage()
        self.codingPath = codingPath
        self.userInfo = [:]
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        guard let topElement = self.storage.elements.last else {
            preconditionFailure("Attempt to get element for new container when no element found.")
        }

        let container = _XMLKeyedEncodingContainer<Key>(encoder: self, element: topElement)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        guard let topElement = self.storage.elements.last else {
            preconditionFailure("Attempt to get element for new container when no element found.")
        }
        
        return _XMLUnkeyedEncodingContainer(encoder: self, element: topElement)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

// MARK: - SingleValueEncodingContainer

extension _XMLEncoder: SingleValueEncodingContainer {
    private func assertCanEncodeNewValue() {
        precondition(self.storage.count > 0, "Attempt to encode value through single value container when previously value already encoded.")
    }

    public func encodeNil() throws {
        assertCanEncodeNewValue()
        topElement.value = nil
    }

    public func encode(_ value: Bool) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Int) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Int8) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Int16) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Int32) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Int64) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: UInt) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: UInt8) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: UInt16) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: UInt32) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: UInt64) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: String) throws {
        assertCanEncodeNewValue()
        topElement.value = self.box(value, with: "").value
    }

    public func encode(_ value: Float) throws {
        assertCanEncodeNewValue()
        topElement.value = try self.box(value, with: "").value
    }

    public func encode(_ value: Double) throws {
        assertCanEncodeNewValue()
        topElement.value = try self.box(value, with: "").value
    }

    public func encode<T: Encodable>(_ value: T) throws {
        assertCanEncodeNewValue()
        let newElement = try self.box(value, with: "")
        topElement.value = newElement.value
        topElement.children += newElement.children
        topElement.attributes.merge(newElement.attributes) { $1 }
    }
}
