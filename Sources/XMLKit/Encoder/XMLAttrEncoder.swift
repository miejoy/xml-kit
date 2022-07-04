//
//  _XMLAttrEncoder.swift
//  
//
//  Created by 黄磊 on 2020-03-23.
//

internal class _XMLAttrEncoder : Encoder {
    
    // MARK: Properties

    let encoder : _XMLEncoder
    let key : String
    let element : _XMLElement
    

    /// Options set on the top-level decoder.
    let options: XMLEncoder._Options

    /// The path to the current point in encoding.
    internal(set) public var codingPath: [CodingKey]

    /// Contextual user-provided information for use during encoding.
    var userInfo: [CodingUserInfoKey : Any] {
        return self.options.userInfo
    }

    // MARK: - Initialization

    /// Initializes `self` with the given top-level container and options.
    init(key: String, element: _XMLElement, encoder: _XMLEncoder) {
        self.key = key
        self.element = element
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.options = encoder.options
    }

    // MARK: - Decoder Methods
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        fatalError("Attr encoder do not have container")
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("Attr encoder do not have container")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }

}


// MARK: - SingleValueEncodingContainer

extension _XMLAttrEncoder : SingleValueEncodingContainer {
    
    func encodeNil() throws {
        self.element.attributes[key] = nil
    }
    
    func encode(_ value: Bool) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: String) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Double) throws {
        self.element.attributes[key] = try self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Float) throws {
        self.element.attributes[key] = try self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Int) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Int8) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Int16) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Int32) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: Int64) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: UInt) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: UInt8) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: UInt16) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: UInt32) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode(_ value: UInt64) throws {
        self.element.attributes[key] = self.encoder.box(value, with: key).value
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        self.element.attributes[key] = try self.encoder.box(value, with: key).value
    }
    
}

