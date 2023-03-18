class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "2fdf93fd49c9375cd14b2fe2e2163cbad4b65d0cfa422c592855e7810036ef56"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff549180bcbf1d1ea82da68872ecbe25b263a19664f3dca390cd8f93c297ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ff549180bcbf1d1ea82da68872ecbe25b263a19664f3dca390cd8f93c297ff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ff549180bcbf1d1ea82da68872ecbe25b263a19664f3dca390cd8f93c297ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "2d269410b7074575aed8403d78d1a05ee65d4fc83fb84d7a695c396e73384e18"
    sha256 cellar: :any_skip_relocation, monterey:       "2d269410b7074575aed8403d78d1a05ee65d4fc83fb84d7a695c396e73384e18"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d269410b7074575aed8403d78d1a05ee65d4fc83fb84d7a695c396e73384e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95a6846850a535addebeea5a2955e5779858cfd74d40eb60b4cb111276c832a"
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
