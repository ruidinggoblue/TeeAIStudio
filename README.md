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
   curl http://localhost:8080/
   # 返回: Welcome to Spring Boot Demo

   curl http://localhost:8080/hello
   # 返回: hello world
   ```

### 方式二：Docker 运行

1. **构建镜像**
   ```bash
   docker build -t teestudio .
   ```

2. **运行容器**
   ```bash
   docker run -p 8080:8080 teestudio
   ```

3. **测试 API**
   ```bash
   curl http://localhost:8080/
   # 返回: Welcome to Spring Boot Demo

   curl http://localhost:8080/hello
   # 返回: Hello from Spring Boot
   ```

## API 接口

| 方法 | 路径 | 描述 | 响应 |
|------|------|------|------|
| GET | / | 欢迎页面 | `Welcome to Spring Boot Demo` |
| GET | /hello | Hello 接口 | `Hello from Spring Boot` |

## 部署到 AWS ECS Fargate

本项目包含 GitHub Actions 工作流，可自动部署到 AWS ECS Fargate + ALB。

### GitHub Secrets 配置

在 GitHub 仓库中配置以下 Secrets（Settings → Secrets and variables → Actions）：

| Secret 名称 | 是否必填 | 描述 |
|-------------|----------|------|
| `AWS_ACCESS_KEY_ID` | ✅ 必填 | AWS IAM 用户的 Access Key ID，需要具有 ECR、ECS、CloudFormation、EC2、ELB、IAM、CloudWatch Logs 等权限 |
| `AWS_SECRET_ACCESS_KEY` | ✅ 必填 | AWS IAM 用户的 Secret Access Key |
| `DOMAIN_NAME` | ❌ 可选 | 您的域名（例如：`api.example.com`），配置后启用 HTTPS |
| `CERTIFICATE_ARN` | ❌ 可选 | ACM 证书 ARN（例如：`arn:aws:acm:us-east-1:123456789:certificate/xxx`） |

### 部署方式

- 推送代码到 `main` 分支，自动触发部署
- 或在 GitHub Actions 页面手动触发工作流

**HTTP 模式（默认）：**
- 只配置 `AWS_ACCESS_KEY_ID` 和 `AWS_SECRET_ACCESS_KEY`
- ALB 监听 80 端口

**HTTPS 模式（可选）：**
- 额外配置 `DOMAIN_NAME` 和 `CERTIFICATE_ARN` 两个 Secrets
- ALB 监听 443 端口，80 端口自动重定向到 443

### 部署配置

- 默认实例数量：1
- 默认区域：us-east-1
- 容器端口：8080

## 项目结构

```
TeeStudio/
├── pom.xml                          # Maven 配置
├── Dockerfile                       # Docker 构建文件
├── README.md                        # 项目说明
├── .gitignore                       # Git 忽略文件
├── .github/
│   ├── workflows/
│   │   └── deploy-ecs.yml           # GitHub Actions 部署工作流
│   └── cloudformation/
│       └── ecs-fargate-alb.yml      # AWS CloudFormation 模板
├── task-definition.json                        # 项目说明
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
