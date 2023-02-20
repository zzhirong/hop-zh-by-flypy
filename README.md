#### 介绍
- 本插件是[hop.nvim](https://github.com/phaazon/hop.nvim)的一个扩展(extension), 它能让 hop 识别中文, 它必须依赖 hop 才能运行, 查看[vim-easymotion-zh](https://github.com/zzhirong/vim-easymotion-zh)获取更详细的介绍.


#### Install 
- 本插件不可独立运行, 它依赖于 hop .
- 使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 进行安装:
```
return {
    'zzhirong/hop-flypy'
    dependencies = 'phaazon/hop.nvim'
}
```

#### 配置
- 将此扩展加入[hop.nvim](https://github.com/phaazon/hop.nvim) extension 配置项.
- 使用 lazy 配置样例:
```lua
return{
    'phaazon/hop.nvim',
    branch = 'v1',
    config = function()
        local hop = require('hop')
        hop.setup {
            keys = 'etovxqpdygfblzhckisuran',
            extension = {
                'zzhirong/hop-flypy'
            }
        }
    end,
}
```

#### 使用
- 通过命令, 本扩展创建了 `HopFlypy1*`, `HopFlypy2*`

#### 帮助
- 查看 hop 对应命令帮助文档, 比如, 想要查看`HopFlypy1`帮助, 

#### 演示
