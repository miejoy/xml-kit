//
//  _XMLDecoder+Unbox.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//

import Foundation


/// 扩展解码中的数据解包方法
extension _XMLDecoder {
    
    internal func unbox(_ element: _XMLElement, as type: Bool.Type) throws -> Bool? {
        
        guard let value = element.value else { return nil }
        
        if value == "true" || value == "1" {
            return true
        } else if value == "false" || value == "0" {
            return false
        }
        
        throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: value)
    }
    
    internal func unbox(_ element: _XMLElement, as type: Int.Type) throws -> Int? {

        guard let string = element.value else { return nil }
        
        guard let value = Int(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: Int8.Type) throws -> Int8? {
        guard let string = element.value else { return nil }
        
        guard let value = Int8(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: Int16.Type) throws -> Int16? {
        guard let string = element.value else { return nil }
        
        guard let value = Int16(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: Int32.Type) throws -> Int32? {
        guard let string = element.value else { return nil }
        
        guard let value = Int32(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: Int64.Type) throws -> Int64? {
        guard let string = element.value else { return nil }
        
        guard let value = Int64(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: UInt.Type) throws -> UInt? {
        guard let string = element.value else { return nil }
        
        guard let value = UInt(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: UInt8.Type) throws -> UInt8? {
        guard let string = element.value else { return nil }
        
        guard let value = UInt8(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: UInt16.Type) throws -> UInt16? {
        guard let string = element.value else { return nil }
        
        guard let value = UInt16(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: UInt32.Type) throws -> UInt32? {
        guard let string = element.value else { return nil }
        
        guard let value = UInt32(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: UInt64.Type) throws -> UInt64? {
        guard let string = element.value else { return nil }
        
        guard let value = UInt64(string) else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
        }
        
        return value
    }
    
    internal func unbox(_ element: _XMLElement, as type: Float.Type) throws -> Float? {
        
        guard let string = element.value else { return nil }

        if let value = Float(string) {
            return value
        } else if case let .convertFromString(posInfString, negInfString, nanString) = self.options.nonConformingFloatDecodingStrategy {
            if string == posInfString {
                return Float.infinity
            } else if string == negInfString {
                return -Float.infinity
            } else if string == nanString {
                return Float.nan
            }
        }
        
        throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
    }
    
    internal func unbox(_ element: _XMLElement, as type: Double.Type) throws -> Double? {
        
        guard let string = element.value else { return nil }
        
        if let double = Double(string) {
            return double
        } else if case let .convertFromString(posInfString, negInfString, nanString) = self.options.nonConformingFloatDecodingStrategy {
            if string == posInfString {
                return Double.infinity
            } else if string == negInfString {
                return -Double.infinity
            } else if string == nanString {
                return Double.nan
            }
        }
        
        throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: string)
    }
    
    internal func unbox(_ element: _XMLElement, as type: String.Type) throws -> String? {
        
        guard let string = element.value else {
            throw DecodingError._typeMismatch(at: codingPath, expectation: type, reality: "")
        }
        
        return string
    }
    
    internal func unbox(_ element: _XMLElement, as type: Date.Type) throws -> Date? {
        
        guard let string = element.value else { return nil }
        
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            self.storage.push(element: element)
            defer { self.storage.popElement() }
            return try Date(from: self)
        case .secondsSince1970:
            let double = try self.unbox(element, as: Double.self)!
            return Date(timeIntervalSince1970: double)
            
        case .millisecondsSince1970:
            let double = try self.unbox(element, as: Double.self)!
            return Date(timeIntervalSince1970: double / 1000.0)
            
        case .iso8601:
            guard let date = s_iso8601Formatter.date(from: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
            }
            
            return date
            
        case .formatted(let formatter):
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Date string does not match format expected by formatter."))
            }
            
            return date
            
        case .custom(let closure):
            self.storage.push(element: element)
            defer { self.storage.popElement() }
            return try closure(self)
        }
    }
    
    internal func unbox(_ element: _XMLElement, as type: Data.Type) throws -> Data? {
        
        guard let string = element.value else { return nil }
        
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            self.storage.push(element: element)
            defer { self.storage.popElement() }
            return try Data(from: self)
            
        case .base64:
            
            guard let data = Data(base64Encoded: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
            }
            
            return data
            
        case .custom(let closure):
            self.storage.push(element: element)
            defer { self.storage.popElement() }
            return try closure(self)
        }
    }
    
    internal func unbox(_ element: _XMLElement, as type: Decimal.Type) throws -> Decimal? {
        
        let doubleValue = try self.unbox(element, as: Double.self)!
        return Decimal(doubleValue)
    }
    
    internal func unbox<T : Decodable>(_ element: _XMLElement, as type: T.Type) throws -> T? {
        let decoded: T
        if type == Date.self || type == NSDate.self {
            guard let date = try self.unbox(element, as: Date.self) else { return nil }
            decoded = date as! T
        } else if type == Data.self || type == NSData.self {
            guard let data = try self.unbox(element, as: Data.self) else { return nil }
            decoded = data as! T
        } else if type == URL.self || type == NSURL.self {
            guard let urlString = try self.unbox(element, as: String.self) else {
                return nil
            }
            
            guard let url = URL(string: urlString) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath,
                                                                        debugDescription: "Invalid URL string."))
            }
            
            decoded = (url as! T)
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            guard let decimal = try self.unbox(element, as: Decimal.self) else { return nil }
            decoded = decimal as! T
        } else {
            self.storage.push(element: element)
            defer { self.storage.popElement() }
            return try type.init(from: self)
        }
        
        return decoded
    }
}
