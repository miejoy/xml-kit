//
//  _XMLEncodingStorage.swift
//  
//
//  Created by 黄磊 on 2020-03-23.
//

import Foundation

/// 主要用于需要将编码传给其他类来处理的情况
/// 使用堆的方式保存正在处理的元素，必须确保 push 和 popElement 是成对出现的。
/// push 之后对应类型会通过 singleValueContainer 编码到 topElement 中
internal struct _XMLEncodingStorage {
    
    // MARK: Properties

    /// The container stack.
    private(set) var elements: [_XMLElement] = []

    // MARK: - Initialization

    /// Initializes `self` with no containers.
    init() {}

    // MARK: - Modifying the Stack

    var count: Int {
        return self.elements.count
    }
    
    var topElement : _XMLElement {
        precondition(!self.elements.isEmpty, "Empty container stack.")
        return self.elements.last!
    }

    mutating func push(element: __owned _XMLElement) {
        self.elements.append(element)
    }

    mutating func popElement() -> _XMLElement {
        precondition(!self.elements.isEmpty, "Empty container stack.")
        return self.elements.popLast()!
    }
}
