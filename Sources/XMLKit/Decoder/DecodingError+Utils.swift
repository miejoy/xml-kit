//
//  DecodingError+Utils.swift
//
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation

/// 错误方法扩展，方便调用
extension DecodingError {
    internal static func _keyNotFound(
        at path: [CodingKey],
        with key: CodingKey,
        strategy: XMLDecoder.KeyDecodingStrategy,
        prevDesc: String? = nil
    ) -> DecodingError {
        var desc: String
        switch strategy {
        case .convertFromSnakeCase:
            // In this case we can attempt to recover the original value by reversing the transform
            let original = key.stringValue
            let converted = XMLEncoder.KeyEncodingStrategy._convertToSnakeCase(original)
            let roundtrip = XMLDecoder.KeyDecodingStrategy._convertFromSnakeCase(converted)
            if converted == original {
                desc = "\(key) (\"\(original)\")"
            } else if roundtrip == original {
                desc = "\(key) (\"\(original)\"), converted to \(converted)"
            } else {
                desc = "\(key) (\"\(original)\"), with divergent representation \(roundtrip), converted to \(converted)"
            }
        case .lowercaseFirstLetter:
            let original = key.stringValue
            let converted = XMLEncoder.KeyEncodingStrategy._uppercaseFirstLetter(original)
            let roundtrip = XMLDecoder.KeyDecodingStrategy._lowercaseFirstLetter(converted)
            if converted == original {
                desc = "\(key) (\"\(original)\")"
            } else if roundtrip == original {
                desc = "\(key) (\"\(original)\"), converted to \(converted)"
            } else {
                desc = "\(key) (\"\(original)\"), with divergent representation \(roundtrip), converted to \(converted)"
            }
        default:
            // Otherwise, just report the converted string
            desc =  "\(key) (\"\(key.stringValue)\")"
        }
        return .keyNotFound(key, DecodingError.Context(
            codingPath: path,
            debugDescription: ((prevDesc != nil) ? prevDesc! + " -- " : "") + "No value associated with key \(desc)."))
    }
    
    internal static func _valueNotFound(at path: [CodingKey], with type: Any.Type) -> DecodingError {
        return .valueNotFound(type, DecodingError.Context(codingPath: path, debugDescription: "Expected \(type) value but found null instead."))
    }
    
    internal static func _valueNotFoundReachEnd(at path: [CodingKey], with type: Any.Type, index: Int) -> DecodingError {
        return .valueNotFound(type, DecodingError.Context(
            codingPath: path + [_XMLKey(index: index)],
            debugDescription: "Unkeyed container is at end."))
    }
    
    internal static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: String) -> DecodingError {
        return .typeMismatch(expectation, Context(
            codingPath: path,
            debugDescription: "Expected to decode \(expectation) but found \(reality) instead."))
    }
}
