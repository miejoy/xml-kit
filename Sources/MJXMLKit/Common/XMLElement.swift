//
//  _XMLElement.swift
//  
//
//  Created by 黄磊 on 2020-03-21.
//

import Foundation

/// XML 解析元素
internal class _XMLElement {
    
    var name: String
    var value: String? = nil
    var attributes: [String: String] = [:]
    var children: [_XMLElement] = []
    
    init(name: String, value: String? = nil, children: [_XMLElement] = []) {
        self.name = name
        self.value = value
        self.children = children
    }
    
    func toXMLString(with header: XMLHeader? = nil, prettyPrinted: Bool) -> String {
        
        if let header = header, let headerXML = header.toXML() {
            return headerXML + _toXMLString(prettyPrinted: prettyPrinted)
        } else {
            return _toXMLString(prettyPrinted: prettyPrinted)
        }
    }
    
    fileprivate func _toXMLString(prettyPrinted: Bool, with depth: Int = 0) -> String {
        var string = prettyPrinted ? String(repeating: " ", count: depth * 4) : ""
        string += "<\(name)"
        
        for (key, value) in attributes {
            string += " \(key)=\"\(value.xmlEscape())\""
        }
        
        if let value = value {
            string += ">"
            string += value.xmlEscape()
            string += "</\(name)>"
        } else if !children.isEmpty {
            string += prettyPrinted ? ">\n" : ">"
            
            for child in children {
                string += child._toXMLString(prettyPrinted: prettyPrinted, with: depth + 1)
                string += prettyPrinted ? "\n" : ""
            }
            
            string += prettyPrinted ? String(repeating: " ", count: depth * 4) : ""
            string += "</\(name)>"
        } else {
            string += " />"
        }
        
        return string
    }
}

let s_xmlEscapedCharacters = [("&", "&amp"), ("<", "&lt;"), (">", "&gt;"), ( "'", "&apos;"), ("\"", "&quot;")]

extension String {
    
    func xmlEscape() -> String {
        var str = self
        
        for item in s_xmlEscapedCharacters {
            str = str.replacingOccurrences(of: item.0, with: item.1, options: .literal)
        }
        
        return str
    }
    
}
