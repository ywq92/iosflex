# 中文HOOK调试工具（FlexCN）

## 项目概述
本项目旨在开发一款基于iOS巨魔安装（无需越狱签名）的IPA安装包形式HOOK调试工具，功能对标Flex3但重构UI界面（全中文交互），聚焦APP调试场景。

## 核心功能
- **应用管理**：列出系统/用户应用，搜索，状态识别。
- **运行时分析**：类列表，方法列表，方法信息解析。
- **HOOK核心**：方法替换，参数修改，条件执行。
- **补丁管理**：保存/导入/导出补丁。
- **日志模块**：实时日志，过滤，保存。

## 技术架构
- **主应用**：SwiftUI + UIKit
- **动态库**：libhooker + Objective-C Runtime + fishhook
- **通信**：Mach Port / IPC

## 目录结构
- `FlexCN/`: 主应用源码 (SwiftUI)
- `FlexCNHook/`: 动态库源码 (Objective-C)
- `Docs/`: 文档
