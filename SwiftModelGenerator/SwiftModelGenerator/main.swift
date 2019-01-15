//
//  main.swift
//  SwiftModelGenerator
//
//  Created by fumi on 2019/1/14.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation

let argv = CommandLine.arguments

if argv.count > 2 {
    print("格式：SwiftModelGenerator filePath [文件格式为JSON文档，最外层为字典类型]")
    exit(1)
}

let filePath = argv.last!

// 解析JSON格式

generatorModel(jsonPath: filePath, className: "GeneratorModel")

