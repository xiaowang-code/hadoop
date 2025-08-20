# Kylin Linux Advanced Server V10 (Sword) 安装 Docker 指南

> 适用于无法访问外网、依赖缺失、`yum install docker-ce` 报错的场景  
> ✅ 已验证：Kylin V10 + Docker CE 26.1.4

## 📌 问题背景

在 **Kylin Linux Advanced Server V10 (Sword)** 上直接使用 `yum install docker-ce` 会遇到以下问题：

- `apt: command not found` → 系统非 Debian/Ubuntu 系列
- `yum-utils`、`epel-release` 无法找到 → 缺少 EPEL 支持
- `fuse-overlayfs` 和 `slirp4netns` 依赖缺失 → 导致 `docker-ce-rootless-extras` 安装失败
- 访问 `get.docker.com` 失败 → SSL 连接被重置（网络限制）

---

## ✅ 解决方案：使用阿里云镜像 + 手动安装（绕过依赖）

本方案通过 **阿里云 Docker CE 镜像源** 安装核心组件，并使用 `rpm --nodeps` 跳过 `rootless-extras` 依赖，确保安装成功。

---

### 步骤 1：添加阿里云 Docker CE 仓库

```bash
cat > /etc/yum.repos.d/docker-ce.repo << 'EOF'
[docker-ce-stable]
name=Docker CE Stable - x86_64
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
enabled=1
EOF
```

### 步骤 2：清理缓存并重建元数据

```bash
yum clean all
yum makecache
```

### 步骤 3：安装核心依赖（不触发 rootless-extras）

```bash
yum install -y containerd.io docker-ce-cli
```

> ✅ containerd.io 和 docker-ce-cli 通常不强制依赖 fuse-overlayfs。

### 步骤 4：手动下载并安装 docker-ce（忽略依赖）

```bash
cd /tmp
wget https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-26.1.4-1.el7.x86_64.rpm
rpm -ivh --nodeps docker-ce-26.1.4-1.el7.x86_64.rpm
```

> ⚠️ --nodeps 表示忽略依赖检查，适用于已知系统可运行的场景。

### 步骤 5：启动并启用 Docker 服务

```bash
systemctl start docker
systemctl enable docker
```

### 步骤 6：验证 Docker 是否安装成功

```bash
docker --version
```

### 步骤 7：配置阿里云镜像加速器（推荐）

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://<your-mirror-id>.mirror.aliyuncs.com"]
}
EOF
sudo systemctl restart docker
```

> 🔗 获取您的专属镜像加速器地址：[阿里云容器镜像服务控制台 → 镜像加速器](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)
