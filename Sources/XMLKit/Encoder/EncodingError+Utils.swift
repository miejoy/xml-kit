//
//  EncodingError+Utils.swift
//
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation

/// 错误方法扩展，方便调用
extension EncodingError {
    internal static func _invalidFloatingPointValue<T: FloatingPoint>(
        _ value: T,
        at codingPath: [CodingKey]
    ) -> EncodingError {
        let valueDescription: String
        if value == T.infinity {
            valueDescription = "\(T.self).infinity"
        } else if value == -T.infinity {
            valueDescription = "-\(T.self).infinity"
        } else {
            valueDescription = "\(T.self).nan"
        }
        
        // swiftlint:disable:next line_length
        let debugDescription = "Unable to encode \(valueDescription) directly in XML. Use XMLEncoder.NonConformingFloatEncodingStrategy.convertToString to specify how the value should be encoded."
        return .invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
