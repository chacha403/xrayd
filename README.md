# Xray

## 概述

本专案用于部署 xray websocket

部署完成后，每次启动应用时，运行的 xray 将始终为最新版本

### 变量

对部署时需设定的变量名称做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `ID` | `11334bce-d7a0-43a3-b862-3e9449eb7650` | VMess 用户主 ID，用于身份验证，为 UUID 格式 |
| `EMAIL` | `love@xray.com` | 为进一步防止被探测所设额外 ID，即 AlterID，范围为 0 至 65535 |
| `WSPATH` | `/` | WebSocket 所使用的 HTTP 协议路径 |

## 接入 CloudFlare

以下两种方式均可以将应用接入 CloudFlare，从而在一定程度上提升速度。

 1. 为应用绑定域名，并将该域名接入 CloudFlare
 2. 通过 CloudFlare Workers 反向代理