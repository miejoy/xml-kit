//
//  Brothers.swift
//  
//
//  Created by 黄磊 on 2020-06-17.
//

import Foundation

protocol AnyBrothers {
    
}

/// 属性包装器，使用它包装的属性将于 XML 标签中的属性绑定
@propertyWrapper
public class Brothers<Value:Codable> : Codable, AnyBrothers {
        
    var value : [Value]?
    
    public var wrappedValue : [Value] {
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
        // 即使是空的我们也要返回一个数组
        self.wrappedValue = (try? container.decode([Value].self)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}
