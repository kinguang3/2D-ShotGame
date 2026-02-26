# 射击游戏 (Shooting Game)

基于 Godot 4.6开发的2D射击游戏。

## 游戏简介

一款快节奏的2D射击游戏，玩家可以选择不同的角色和武器进行战斗。

## 功能特性

- **多种角色选择**：Bunny（兔子）、Dog（狗）、Cat（猫）、Mouse（老鼠）
- **丰富武器库**：AK47、Pistol、Mac10、Mp5、Shotgun、Sniper、Uzi
- **角色养成**：每个角色拥有不同的生命值、移动速度和魔法值
- **武器系统**：每种武器具有不同的伤害、射速、子弹散射等属性
- **游戏设置**：支持音乐、音效开关，全屏模式切换
- **存档系统**：自动保存游戏设置

## 操作说明

| 按键 | 功能 |
|------|------|
| W | 向上移动 |
| A | 向左移动 |
| S | 向下移动 |
| D | 向右移动 |

## 项目结构

```
射击游戏/
├── Script/           # 游戏脚本
│   ├── global.gd     # 全局脚本（角色/武器数据管理）
│   ├── mainmenu.gd   # 主菜单
│   └── transition.gd # 场景过渡
├── UI/               # 用户界面
│   ├── PlayerCard/   # 角色卡片
│   ├── WeaponCard/  # 武器卡片
│   └── CharacterSelection/ # 角色选择界面
├── Data/             # 游戏数据资源
│   ├── Player/       # 角色数据
│   └── Weapons/      # 武器数据
├── Weapon/           # 武器场景
│   └── Range/        # 远程武器
├── Arena/            # 战斗场景
└── 游戏素材/         # 音效资源
```

## 技术栈

- **引擎**：Godot 4.6
- **渲染**：GL Compatibility
- **物理**：Jolt Physics
- **音频**：Godot Audio System

## 运行方式

1. 下载并安装 [Godot 4.6](https://godotengine.org/)
2. 打开项目文件夹
3. 点击运行按钮或按 F5 启动游戏

## 版本

- 项目版本：1.0.0
- Godot 版本：4.6
- 目标平台：Windows

## 许可证

本项目仅供学习使用。
