
//
//  JSONParse.swift
//  SwiftModelGenerator
//
//  Created by fumi on 2019/1/14.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation

var containers:[String:[String:Any]] = [String:[String:Any]]()

/** 文档位置，类名使用 */
func generatorModel(jsonPath:String, className:String) {
    let content = try? String.init(contentsOfFile: jsonPath)
    
    // 将JSON转换为字典或数组类型，先处理字典类型
    guard let data = content?.data(using: String.Encoding.utf8) else {
        print("格式转换错误")
        return
    }
    guard let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
        print("格式转换错误")
        return
    }
    
    // 使用反射机制进行配置
    if dict is [String:Any] {
        parseDictionaryFromJsonObject(jsonObject: dict as! [String:Any], className: className)
        
        for (key, value) in containers {
            generatorModel(dictionary: value, className: "SwiftModel" + key)
        }
    }
    
}

fileprivate func parseDictionaryFromJsonObject(jsonObject:[String:Any], className:String) {
    containers[className] = jsonObject
    
    // 对JSONObjct进行处理
//    抽离出所有的子级
    for (key,value) in jsonObject {
        if let data = value as? [Any] {
            if let element = data.first as? [String:Any] {
                parseDictionaryFromJsonObject(jsonObject: element, className: key)
            }
        } else if let data = value as? [String: Any] {
            parseDictionaryFromJsonObject(jsonObject: data, className: key)
        }
    }
}



fileprivate func generatorModel(dictionary:[String:Any], className:String) {
    // 将所有字典结构搞出来，然后进行配置即可
    let headerString = """
    class \(className) {
    """
    print(headerString)
    showContainerMessage(dictionary: dictionary)
    
    let footerString = """

    required init() {}
}
"""
    print(footerString)
}


// 根据字典类型进行那个解析数据
fileprivate func showContainerMessage(dictionary:[String:Any]) {
    // 打印结构，不需要考虑内层，只需要考虑外层信息即可
    // 获取所有信息
    let mirror = Mirror(reflecting: dictionary)
    for (label, value) in mirror.children {
        
        // 如果label为空，说明为顶层信息，使用className进行配置即可
        if label != nil {return}
        
        let subMirror = Mirror(reflecting: value)
        var tempString = "\t/** <#desc#> */\n\tvar "
        
        var lastKey = ""
        for (label1, value1) in subMirror.children {
            if label1 == "key" {            // 是Key值，如果是
                tempString.append("\(value1): ")
                lastKey = value1 as! String
            } else if label1 == "value" {
                
                let mirror = Mirror(reflecting: value1)
                
                let type = String(describing: mirror.subjectType)
                
//                print("type:\(type)")
                if type.contains("Number") {
                    tempString.append("NSNumber = 0")
                } else if type.contains("Array") {
                    tempString.append("[SwiftModel\(lastKey)]?")
                } else if type.contains("String") {
                    tempString.append("String?")
                } else if type.contains("Null") {
                    tempString.append("Any?")
                } else if type.contains("Dictionary") {
                    tempString.append("[String:SwiftModel\(lastKey)]?")
                }
                
                // 判断key对应的值的类型
                print(tempString)
            }
        }
    }

}


