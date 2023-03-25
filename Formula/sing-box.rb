class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.0.tar.gz", using: :homebrew_curl
  sha256 "ec70c2eecf85788e82c29ec4ca129e25292d5fc66a510b4b713fe337650740a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6339b233ff9ff16ef0e7f7f20ffd5a2ea10eb29d26357388aca3383ed3448a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6339b233ff9ff16ef0e7f7f20ffd5a2ea10eb29d26357388aca3383ed3448a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6339b233ff9ff16ef0e7f7f20ffd5a2ea10eb29d26357388aca3383ed3448a5"
    sha256 cellar: :any_skip_relocation, ventura:        "569942b88fcb441dd7160e47ef53e7065790579f0f98e96266f408919e3ba568"
    sha256 cellar: :any_skip_relocation, monterey:       "569942b88fcb441dd7160e47ef53e7065790579f0f98e96266f408919e3ba568"
    sha256 cellar: :any_skip_relocation, big_sur:        "569942b88fcb441dd7160e47ef53e7065790579f0f98e96266f408919e3ba568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbaab98f3939aaa211fa0bf8f24797821b60ffed6ae6b1fe13d6aa0ac523c56c"
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
