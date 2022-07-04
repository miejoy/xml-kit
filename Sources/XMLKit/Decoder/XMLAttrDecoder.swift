//
//  _XMLAttrDecoder.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

/// 属性解码器
internal class _XMLAttrDecoder : Decoder {
    
    // MARK: Properties

    let decoder : _XMLDecoder
    let key : String
    let content : String?
    
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
    init(key: String, content: String?, decoder: _XMLDecoder) {
        self.key = key
        self.content = content
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        self.options = decoder.options
    }

    // MARK: - Decoder Methods

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        throw DecodingError.valueNotFound(KeyedDecodingContainer<Key>.self,
                                          DecodingError.Context(codingPath: self.codingPath,
                                                                debugDescription: "Attr decoder do not have container"))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
                                          DecodingError.Context(codingPath: self.codingPath,
                                                                debugDescription: "Attr decoder do not have container"))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}


extension _XMLAttrDecoder : SingleValueDecodingContainer {
    
    private func expectNonNil<T>(_ type: T.Type) throws {
        guard !self.decodeNil() else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected \(type) but found null value instead."))
        }
    }
    
    func decodeNil() -> Bool {
        return content == nil
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        try expectNonNil(Bool.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Bool.self)!
    }
    
    func decode(_ type: String.Type) throws -> String {
        try expectNonNil(String.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: String.self)!
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        try expectNonNil(Double.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Double.self)!
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        try expectNonNil(Float.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Float.self)!
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        try expectNonNil(Int.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Int.self)!
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNonNil(Int8.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Int8.self)!
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNonNil(Int16.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Int16.self)!
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNonNil(Int32.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Int32.self)!
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNonNil(Int64.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: Int64.self)!
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        try expectNonNil(UInt.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: UInt.self)!
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNonNil(UInt8.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: UInt8.self)!
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNonNil(UInt16.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: UInt16.self)!
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNonNil(UInt32.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: UInt32.self)!
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNonNil(UInt64.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: UInt64.self)!
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try expectNonNil(T.self)
        return try self.decoder.unbox(_XMLElement(name: key, value: content), as: T.self)!
    }
}
