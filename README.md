# 微聊 iOS 版 — 工程与上线说明

## 这个文件夹里是什么

完整的 iOS APP 工程（Swift + WKWebView 壳，与安卓版功能对应）：

```
ios-app/
├── project.yml              # XcodeGen 工程描述（自动生成 .xcodeproj）
├── Weiliao/
│   ├── WeiliaoApp.swift     # 主程序：全屏 WebView + 断网重试 + 侧滑返回
│   ├── Info.plist 自动生成   # 已配置：显示名"微聊"、允许 HTTP、启动屏
│   └── Assets.xcassets/     # 你的绿色"微聊"图标（1024px）
└── .github/workflows/ios.yml  # GitHub Actions 云端编译（免 Mac 出 IPA）
```

## 工作原理

1. 把本文件夹推到 GitHub 仓库 → GitHub 免费的 macOS 云电脑自动编译出 **未签名 IPA**
2. 签名 + 装到 iPhone 由下面的「你必须做的 3 件事」完成

## ⚠️ 必须由你本人完成的 3 件事（苹果的规定，谁也替代不了）

### 事 1：注册 GitHub 账号（免费，5 分钟）
- github.com 注册 → 把 ios-app 文件夹上传到仓库（网页上点 Add file 逐个传也行，文件很少）
- 上传后进入 Actions 页面，等编译完成，在 Artifacts 里下载 `Weiliao-unsigned.ipa`

### 事 2：选择签名方式（二选一）

| 方式 | 费用 | 有效期 | 能否给群友装 |
|---|---|---|---|
| **A. 苹果开发者账号**（正式方案） | 688 元/年 | 长期 | ✅ 通过 TestFlight 邀请，最多 1 万人 |
| B. 免费 Apple ID + Sideloadly 侧载 | 0 元 | **每 7 天过期** | ❌ 只能装在你自己手机 |

注册开发者账号：iPhone 上打开 App Store 搜 "Developer"，或在 developer.apple.com 用你的 Apple ID 注册，需实名 + 付款。

### 事 3：签名安装

- **方式 A（推荐）**：开发者账号下来后，在 developer.apple.com 生成证书，TestFlight 上传（可由我把 workflow 升级成自动签名+上传 TestFlight，只需在 GitHub 填入证书密钥），群友装 TestFlight App 后点你的邀请链接即可安装
- **方式 B（快速体验）**：Windows 装 Sideloadly（sideloadly.io），手机连电脑，选 IPA → 输入你的 Apple ID → Start，装完在 设置→通用→VPN与设备管理 里信任企业证书/开发者 App

## 说句实在话

- 代码、工程、云编译我已全部就绪，**不花钱的免费侧载路线 7 天就要重签一次**，不适合给群友用
- 要给群友长期用，688 元/年的开发者账号绕不开——这是苹果收费，不是代办费
- 你注册好账号后告诉我走哪条路线，剩下的配置我继续帮你做完
