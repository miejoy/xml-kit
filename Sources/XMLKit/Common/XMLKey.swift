//
//  _XMLKey.swift
//
//
//  Created by 黄磊 on 2020-03-22.
//

/// XML 编码/解码 通用 Key
internal struct _XMLKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index\(index)"
        self.intValue = index
    }

    static let `super` = _XMLKey(stringValue: "super")!
}
