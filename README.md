# SwiftModelGenerator
根据JSON结构快速生成模型结构



#### 1. 编译生成可执行文件

#### 2. 执行命令

```
./SwiftModelGenerator jsonFilePath
```

```
// 示例JSON
{
	"data": {
		"user_id": "764511",
		"user_name": "肥宅她大哥",
		"alipay_status": "2"
	},
	"msg": "success",
	"code": "200"
}
```



#### 3. 转换后的结果为

```
class SwiftModeldata {
	/** <#desc#> */
	var user_id: String?
	/** <#desc#> */
	var user_name: String?
	/** <#desc#> */
	var alipay_status: String?

    required init() {}
}
class SwiftModelGeneratorModel {
	/** <#desc#> */
	var msg: String?
	/** <#desc#> */
	var data: [String:SwiftModeldata]?
	/** <#desc#> */
	var code: String?

    required init() {}
}
```

