class Redisw < Formula
  desc "命令行下的 Redis 服务器连接管理工具，支持多服务器快速切换的终端工具"
  homepage "https://github.com/zhaojy0527/redisw"
  url "https://github.com/zhaojy0527/redisw/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c4c7006d6f798e0a328101385380edef05e2e2c1891e2ffb4988b088f014f564"
  license "MIT"

  depends_on "go" => :build
  depends_on "redis"

  def install
    system "make", "build"
    bin.install "redisw"
  end

  test do
    # 创建测试配置文件
    (testpath/"redisw_config.yml").write <<~EOS
      - name: "test"
        host: "localhost"
        port: 6379
        password: ""
    EOS

    # 只测试帮助信息
    assert_match "-config", shell_output("#{bin}/redisw -h 2>&1")
  end
end
