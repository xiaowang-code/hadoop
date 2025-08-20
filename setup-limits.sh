#!/bin/bash

# ============================================================================
#          一键系统优化脚本：安装 nano + 配置资源限制
# 适用场景：Hadoop / Docker / Hive / Elasticsearch 等大数据环境
# 功能：自动安装 nano，配置 ulimit 和 sysctl，适用于 Alibaba Cloud Linux / CentOS
# ============================================================================

# 检查是否为 root 或具有 sudo 权限的用户
if ! command -v sudo &> /dev/null; then
    echo "❌ 错误：系统未安装 sudo，请以 root 用户运行此脚本。"
    exit 1
fi

# 1. 安装 nano 编辑器
echo "🔧 正在安装 nano 编辑器..."
sudo yum makecache -q || { echo "❌ 更新包缓存失败"; exit 1; }
sudo yum install -y nano || { echo "❌ 安装 nano 失败"; exit 1; }

# 2. 配置用户资源限制 limits.conf
echo "📝 正在配置 /etc/security/limits.conf ..."
sudo cat >> /etc/security/limits.conf << 'EOF'

# === BigData & Docker Optimization (Auto-Configured) ===
*               soft    nofile          1000000
*               hard    nofile          1000000
*               soft    nproc           1000000
*               hard    nproc           1000000
*               soft    stack           65536
*               hard    stack           65536
# =======================================================
EOF

# 3. 配置内核参数 sysctl.conf
echo "⚙️ 正在配置 /etc/sysctl.conf ..."
sudo cat >> /etc/sysctl.conf << 'EOF'

# === Kernel Tuning for Hadoop/Docker (Auto-Configured) ===
vm.max_map_count = 262144
fs.file-max = 9223372036854775807
# ========================================================
EOF

# 4. 立即应用内核参数
echo "🔄 正在应用 sysctl 配置..."
sudo sysctl -p

# 5. 输出完成提示
echo ""
echo "✅ 系统资源优化配置已完成！"
echo "📌 请退出终端并重新登录，以使 ulimit 生效。"
echo ""
echo "🔍 验证命令（重新登录后执行）："
echo "    ulimit -n                    # 预期输出：1000000"
echo "    ulimit -u                    # 预期输出：1000000"
echo "    ulimit -s                    # 预期输出：65536"
echo "    cat /proc/sys/vm/max_map_count    # 预期输出：262144"
echo "    cat /proc/sys/fs/file-max         # 应为极大值"

# 结束 