// 
//  WYCodableObjc.swift
//  WYBasisKit
//
//  Created by 官人 on 2024/1/22.
//

import Foundation

/// Key 解码策略枚举
@objc public enum WYKeyDecodingStrategyObjc: Int {
    
    /// 使用默认的键值策略，不进行任何转换
    case useDefaultKeys = 0
    
    /// 将蛇形命名法转换为驼峰命名法（例如：first_name -> firstName）
    case convertFromSnakeCase
    
    /// 使用自定义的键名转换策略(注意：此策略在 Objective-C 中无法直接使用，需要在 Swift 中设置自定义闭包)
    case custom
}

//@objcMembers open class WYCodableObjc: JSONDecoder, @unchecked Sendable {
//    
//    /// 解析时需要映射的Key的策略(仅针对第一层数据映射，第二层级以后的(第一层也可以)建议在对应的model类中使用Codable原生映射方法)
//    open var mappingKeys: WYKeyDecodingStrategyObjc = .useDefaultKeys
//    
//    /// 将Data类型数据解析成传入的Model类型
//    open override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
//        return 
//    }
//}
