class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.6.tar.gz", using: :homebrew_curl
  sha256 "8f7adf55ed9afe6ec0dd8b04ed64dd3a6243578ee779f909dfb3778fa2dbda10"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af35409f5cf18d7713cb1d848b35c5398527817cd4edf789c602b7a464c40bb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af35409f5cf18d7713cb1d848b35c5398527817cd4edf789c602b7a464c40bb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af35409f5cf18d7713cb1d848b35c5398527817cd4edf789c602b7a464c40bb9"
    sha256 cellar: :any_skip_relocation, ventura:        "c0c54532b1412e621752f3035153b4a08d38a39e9b6ded5e49fed23045286c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0c54532b1412e621752f3035153b4a08d38a39e9b6ded5e49fed23045286c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c54532b1412e621752f3035153b4a08d38a39e9b6ded5e49fed23045286c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01300f3e662cc4dca7fbf95e7b3f800188946eaaedf698a43d25a573042114fa"
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
