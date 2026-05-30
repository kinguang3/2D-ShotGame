# BlackShot

基于 **Godot 4.6** 开发的2D射击游戏。

## 🎮 游戏简介

一款快节奏的2D地牢射击游戏，玩家可以选择不同的角色和武器，探索随机生成的地牢，击败敌人获取金币和道具。

## ✨ 功能特性

### 核心玩法
- **随机地牢生成**：每次游戏生成不同的地牢布局
- **多种角色选择**：Bunny（兔子）、Dog（狗）、Cat（猫）、Mouse（老鼠）、Shooter（射手）
- **丰富武器库**：AK47、Pistol、Mac10、Mp5、Shotgun、Sniper、Uzi等多种武器
- **敌人生成系统**：根据房间类型生成不同难度的敌人

### 角色养成
- 每个角色拥有不同的生命值、移动速度和魔法值
- 武器系统具有不同的伤害、射速、子弹散射等属性
- 支持物品拾取和使用（药水、金币等）

### 游戏界面
- 角色选择界面
- 实时血条和金币显示
- 暂停菜单系统
- 地图显示

### 游戏设置
- 支持音乐、音效开关
- 全屏模式切换
- 自动保存游戏设置

## 🎯 操作说明

| 按键 | 功能 |
|------|------|
| W / ↑ | 向上移动 |
| A / ← | 向左移动 |
| S / ↓ | 向下移动 |
| D / → | 向右移动 |
| 鼠标左键 | 射击 |
| 空格 | 跳跃 |
| ESC | 暂停菜单 |

## 📁 项目结构

```
BlackShot/
├── Arena/                 # 战斗场景
│   ├── arena.gd           # 战斗场景脚本
│   ├── arena.tscn         # 战斗场景
│   ├── enemy_spawner.gd   # 敌人生成器
│   └── map_controller.gd  # 地图控制器
├── Autoloads/             # 自动加载节点
│   ├── cursor.tscn        # 鼠标光标
│   ├── event_bus.gd       # 事件总线
│   └── transition.tscn    # 场景过渡
├── Bullet/                # 子弹相关
│   └── Enemy/             # 敌人子弹
├── Componets/             # 组件
│   └── health_componet.gd # 生命组件
├── Data/                  # 游戏数据资源
│   ├── Items/             # 物品数据
│   ├── Level/             # 关卡数据
│   ├── Player/            # 角色数据
│   └── Weapons/           # 武器数据
├── Enemy/                 # 敌人相关
│   ├── enemy_1.gd         # 敌人脚本
│   └── enemy_1.tscn       # 敌人场景
├── Extra/                 # 额外资源
│   ├── chest.tscn         # 宝箱
│   └── portal.tscn        # 传送门
├── Item/                  # 物品
│   ├── coins.tscn         # 金币
│   └── store_item.tscn    # 商店物品
├── Levels/                # 关卡房间
│   └── level_01_room.tscn # 房间场景
├── Player/                # 玩家相关
│   ├── player.gd          # 玩家脚本
│   └── player_base.tscn   # 玩家基础场景
├── Script/                # 游戏脚本
│   ├── global.gd          # 全局脚本（数据管理）
│   ├── mainmenu.gd        # 主菜单
│   └── transition.gd      # 场景过渡
├── Shaders/               # 着色器
│   └── vignette.gdshader  # 暗角效果
├── UI/                    # 用户界面
│   ├── CharacterSelection/ # 角色选择
│   ├── MapCell/           # 地图单元格
│   ├── Pause/             # 暂停菜单
│   ├── PlayerCard/        # 角色卡片
│   └── WeaponCard/        # 武器卡片
├── Weapon/                # 武器场景
│   ├── Melee/             # 近战武器
│   └── Range/             # 远程武器
├── Game Resourses/        # 游戏素材
└── project.godot          # 项目配置
```

## 🛠️ 技术栈

| 组件 | 技术 |
|------|------|
| 引擎 | Godot 4.6 |
| 渲染 | GL Compatibility |
| 物理 | Jolt Physics |
| 音频 | Godot Audio System |
| 平台 | Windows Desktop (x86_64) |
| 多人服务 | FastAPI |

## 🚀 运行方式

### 方式一：直接运行可执行文件
1. 下载 `Game/射击游戏.exe`
2. 双击运行即可

### 方式二：使用Godot引擎运行
1. 下载并安装 [Godot 4.6](https://godotengine.org/)
2. 打开项目文件夹
3. 点击运行按钮或按 F5 启动游戏

## 📜 许可证

本项目仅供学习使用。

## 📝 更新日志

### v1.0.0
- 完成版发布
- 添加传送门系统
- 添加vignette着色器
- 优化游戏性能
- 添加暂停菜单功能