//
//  _XMLDecodingStorage.swift
//  
//
//  Created by 黄磊 on 2020-03-22.
//


/// 主要用于需要将编码传给其他类来处理的情况
/// 使用堆的方式保存正在处理的元素，一般 push 和 popElement 是成对出现的。
/// push 之后对应类型会通过 singleValueContainer 读取 topElement 继续进行解码
internal struct _XMLDecodingStorage {

    
    private(set) internal var elements: [_XMLElement] = []

    // MARK: - Init

    init() {}

    // MARK: -

    var count: Int {
        return self.elements.count
    }

    var topElement: _XMLElement {
        precondition(!self.elements.isEmpty, "Empty container stack.")
        return self.elements.last!
    }

    mutating func push(element: _XMLElement) {
        self.elements.append(element)
    }

    mutating func popElement() {
        precondition(!self.elements.isEmpty, "Empty container stack.")
        self.elements.removeLast()
    }
}
