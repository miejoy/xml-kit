//
//  _XMLEncoder+Box.swift
//
//
//  Created by 黄磊 on 2020-03-23.
//

import Foundation

extension _XMLEncoder {
    func box(_ value: Bool, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: Int, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: Int8, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: Int16, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: Int32, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: Int64, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: UInt, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: UInt8, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: UInt16, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: UInt32, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: UInt64, with key: String) -> _XMLElement { return _XMLElement(name: key, value: "\(value)") }
    func box(_ value: String, with key: String) -> _XMLElement { return _XMLElement(name: key, value: value) }

    func box(_ float: Float, with key: String) throws -> _XMLElement {
        let str: String
        if float.isInfinite || float.isNaN {
            if case let .convertToString(positiveInfinity: posInfString,
                                            negativeInfinity: negInfString,
                                            nan: nanString) = self.options.nonConformingFloatEncodingStrategy {
                if float == Float.infinity {
                    str = posInfString
                } else if float == -Float.infinity {
                    str = negInfString
                } else {
                    str = nanString
                }
            } else {
                throw EncodingError._invalidFloatingPointValue(float, at: codingPath)
            }
        } else {
            str = "\(float)"
        }

        return _XMLElement(name: key, value: str)
    }

    func box(_ double: Double, with key: String) throws -> _XMLElement {
        let str: String
        if double.isInfinite || double.isNaN {
            if case let .convertToString(positiveInfinity: posInfString,
                                            negativeInfinity: negInfString,
                                            nan: nanString) = self.options.nonConformingFloatEncodingStrategy {
                if double == Double.infinity {
                    str = posInfString
                } else if double == -Double.infinity {
                    str = negInfString
                } else {
                    str = nanString
                }
            } else {
                throw EncodingError._invalidFloatingPointValue(double, at: codingPath)
            }
        } else {
            str = "\(double)"
        }

        return _XMLElement(name: key, value: str)
    }

    func box(_ date: Date, with key: String) throws -> _XMLElement {
        switch self.options.dateEncodingStrategy {
        case .deferredToDate:
            self.storage.push(element: _XMLElement(name: key))
            try date.encode(to: self)
            return self.storage.popElement()

        case .secondsSince1970:
            return _XMLElement(name: key, value: date.timeIntervalSince1970.description)

        case .millisecondsSince1970:
            return _XMLElement(name: key, value: (1000.0 * date.timeIntervalSince1970).description)

        case .iso8601:
            return _XMLElement(name: key, value: s_iso8601Formatter.string(from: date))
        case .formatted(let formatter):
            return _XMLElement(name: key, value: formatter.string(from: date))

        case .custom(let closure):
            let depth = self.storage.count
            do {
                self.storage.push(element: _XMLElement(name: key))
                try closure(date, self)
            } catch {
                if self.storage.count > depth {
                    _ = self.storage.popElement()
                }

                throw error
            }

            guard self.storage.count > depth else {
                return _XMLElement(name: key, value: nil)
            }

            return self.storage.popElement()
        }
    }

    func box(_ data: Data, with key: String) throws -> _XMLElement {
        switch self.options.dataEncodingStrategy {
        case .deferredToData:

            let depth = self.storage.count
            do {
                self.storage.push(element: _XMLElement(name: key))
                try data.encode(to: self)
            } catch {
                if self.storage.count > depth {
                    _ = self.storage.popElement()
                }
                throw error
            }

            return self.storage.popElement()

        case .base64:
            return _XMLElement(name: key, value: data.base64EncodedString())

        case .custom(let closure):
            let depth = self.storage.count
            do {
                self.storage.push(element: _XMLElement(name: key))
                try closure(data, self)
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                if self.storage.count > depth {
                    _ = self.storage.popElement()
                }

                throw error
            }

            guard self.storage.count > depth else {
                // The closure didn't encode anything. Return the default keyed container.
                return _XMLElement(name: key, value: nil)
            }

            // We can pop because the closure encoded something.
            return self.storage.popElement()
        }
    }

    func box(_ value: Encodable, with key: String) throws -> _XMLElement {
        return try self.box_(value, with: key) ?? _XMLElement(name: key, value: nil)
    }
    
    // swiftlint:disable force_cast

    // This method is called "box_" instead of "box" to disambiguate it from the overloads. Because the return type here is different from all of the "box" overloads (and is more general), any "box" calls in here would call back into "box" recursively instead of calling the appropriate overload, which is not what we want.
    func box_(_ value: Encodable, with key: String) throws -> _XMLElement? {
        let type = Swift.type(of: value)
        if type == Date.self || type == NSDate.self {
            // Respect Date encoding strategy
            return try self.box((value as! Date), with: key)
        } else if type == Data.self || type == NSData.self {
            // Respect Data encoding strategy
            return try self.box((value as! Data), with: key)
        } else if type == URL.self || type == NSURL.self {
            // Encode URLs as single strings.
            return self.box((value as! URL).absoluteString, with: key)
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            // JSONSerialization can natively handle NSDecimalNumber.
            return _XMLElement(name: key, value: (value as! NSDecimalNumber).description)
        }

        let depth = self.storage.count
        do {
            self.storage.push(element: _XMLElement(name: key))
            try value.encode(to: self)
        } catch {
            if self.storage.count > depth {
                _ = self.storage.popElement()
            }
            throw error
        }

        guard self.storage.count > depth else {
            return nil
        }

        return self.storage.popElement()
    }
    
    // swiftlint:enable force_cast
}
