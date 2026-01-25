# Spring Boot Demo

一个简单的 Spring Boot 演示项目，提供 `GET /hello` API 返回 "hello world"。

## 环境要求

- macOS
- Java 17+
- Maven 3.6+
- Docker（可选）

## 快速开始

### 方式一：本地运行

1. **安装 Java 17（如未安装）**
   ```bash
   brew install openjdk@17
   ```

2. **安装 Maven（如未安装）**
   ```bash
   brew install maven
   ```

3. **运行项目**
   ```bash
   mvn spring-boot:run
   ```

4. **测试 API**
   ```bash
   curl http://localhost:8080/hello
   # 返回: hello world
   ```

### 方式二：Docker 运行

1. **构建镜像**
   ```bash
   docker build -t springbootdemo .
   ```

2. **运行容器**
   ```bash
   docker run -p 8080:8080 springbootdemo
   ```

3. **测试 API**
   ```bash
   curl http://localhost:8080/hello
   # 返回: hello world
   ```

## API 接口

| 方法 | 路径 | 描述 | 响应 |
|------|------|------|------|
| GET | /hello | Hello World 接口 | `hello world` |

## 项目结构

```
TeeStudio/
├── pom.xml                          # Maven 配置
├── Dockerfile                       # Docker 构建文件
├── README.md                        # 项目说明
└── src/
    └── main/
        ├── java/
        │   └── com/example/TeeStudio/
        │       ├── TeeStudioApplication.java   # 启动类
        │       └── controller/
        │           └── HelloController.java         # API 控制器
        └── resources/
            └── application.properties               # 应用配置
```

## 端口

默认端口：`8080`
