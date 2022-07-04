//
//  File.swift
//  
//
//  Created by 黄磊 on 2020-03-25.
//

import Foundation

protocol AnyPlaintext {
    
}

/// 属性包装器，使用它包装的属性将于 XML 标签中的属性绑定
@propertyWrapper
public class Plaintext<Value:Codable> : Codable, AnyPlaintext {
        
    var value : Value?
    
    public var wrappedValue : Value {
        get {
            guard let value = self.value else {
                fatalError("Cannot access field before it is initialized or fetched")
            }
            return value
        }
        set {
            value = newValue
        }
    }
    
    public required init() {
        self.value = nil
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let valueType = Value.self as? _AnyOptionalType.Type {
            if container.decodeNil() {
                self.wrappedValue = (valueType.nil as! Value)
            } else {
                self.wrappedValue = try container.decode(Value.self)
            }
        } else {
            self.wrappedValue = try container.decode(Value.self)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
    
}
