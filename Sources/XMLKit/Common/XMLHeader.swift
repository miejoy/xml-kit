//
//  XMLHeader.swift
//
//
//  Created by 黄磊 on 2020-03-21.
//

import Foundation


/// XML 头部包装类
public struct XMLHeader {
    var version: Double?
    var encoding: String?
    var standalone: String?
    
    public init(version: Double?, encoding: String? = nil, standalone: String? = nil) {
        self.version = version
        self.encoding = encoding
        self.standalone = standalone
    }
    
    internal func isEmpty() -> Bool {
        return version == nil && encoding == nil && standalone == nil
    }
    
    internal func toXML() -> String? {
        guard !self.isEmpty() else { return nil }
        
        var string = "<?xml "
        
        if let version = version {
            string += "version=\"\(version)\" "
        }
        
        if let encoding = encoding {
            string += "encoding=\"\(encoding)\" "
        }
        
        if let standalone = standalone {
            string += "standalone=\"\(standalone)\""
        }
        
        return string.trimmingCharacters(in: .whitespaces) + "?>\n"
    }
}
