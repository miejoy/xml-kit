//
//  Attr.swift
//  
//
//  Created by 黄磊 on 2020-03-21.
//

import Foundation

/// 任意属性协议，方便 Decoder 和 Encoder 操作
protocol AnyAttr {
    
}

/// 属性包装器，使用它包装的属性将于 XML 标签中的属性绑定
@propertyWrapper
public class Attr<Value:Codable> : Codable, AnyAttr {
        
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
        if Value.self is _AnyOptionalType.Type {
            if let value = self.value {
                try container.encode(value)
            } else {
                try container.encodeNil()
            }
        } else {
            try container.encode(self.wrappedValue)
        }
    }
}

// MARK: - AnyOption

protocol _AnyOptionalType {
    static var wrappedType: Any.Type { get }
    static var `nil`: Any { get }
    var wrappedValue: Any? { get }
}

protocol _OptionalType: _AnyOptionalType {
    associatedtype Wrapped
}

extension _OptionalType {
    public static var wrappedType: Any.Type {
        return Wrapped.self
    }
}

extension Optional: _OptionalType {
    public static var `nil`: Any {
        Self.none as Any
    }

    public var wrappedValue: Any? {
        self
    }
}


