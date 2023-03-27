class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.1.tar.gz", using: :homebrew_curl
  sha256 "0f304b75c2e9f61e3f7808f23fe8fbe08161553475d9bec0dea4a5acf4452d2d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d2cb7589924cefc01a5d45b1be8e84397b9c67eaabeb8b96692eccdc8dfc80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d2cb7589924cefc01a5d45b1be8e84397b9c67eaabeb8b96692eccdc8dfc80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4d2cb7589924cefc01a5d45b1be8e84397b9c67eaabeb8b96692eccdc8dfc80"
    sha256 cellar: :any_skip_relocation, ventura:        "df5ca5c95b8c5c139b487af7aa493d6482ff18ee46f143bca451cd55cf4eb175"
    sha256 cellar: :any_skip_relocation, monterey:       "df5ca5c95b8c5c139b487af7aa493d6482ff18ee46f143bca451cd55cf4eb175"
    sha256 cellar: :any_skip_relocation, big_sur:        "df5ca5c95b8c5c139b487af7aa493d6482ff18ee46f143bca451cd55cf4eb175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2abb1a0217c114460fb7b13dc6b80889394cf495c7cd99fcaece229072936ea7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    server = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~EOS
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    EOS
    system "#{bin}/sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", "config.json" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
