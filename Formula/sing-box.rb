class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.3.tar.gz", using: :homebrew_curl
  sha256 "a12b81950deb181cf2c1783685e0dd66502376471db57e3787fad3f3e27fd48c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b6fa3ce9646d7241e507e6022f09daebef3b0ab33c0fad348172787edd9d4ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b6fa3ce9646d7241e507e6022f09daebef3b0ab33c0fad348172787edd9d4ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b6fa3ce9646d7241e507e6022f09daebef3b0ab33c0fad348172787edd9d4ff"
    sha256 cellar: :any_skip_relocation, ventura:        "7c44c3c59299f606103f62148113b4d14a2ee47888c1f09d4e763c113e9acbec"
    sha256 cellar: :any_skip_relocation, monterey:       "7c44c3c59299f606103f62148113b4d14a2ee47888c1f09d4e763c113e9acbec"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c44c3c59299f606103f62148113b4d14a2ee47888c1f09d4e763c113e9acbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caa0731210b2c2a3d54fdcf480c645be98cfc7cebc04b8167f81f2c5c73dc81f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
  end

  def post_install
    (etc/"sing-box").mkpath
    (var/"sing-box").mkpath
  end

  service do
    run [opt_bin/"sing-box", "run", "-C", etc/"sing-box"]
    keep_alive true
    working_dir var/"sing-box"
    error_log_path var/"log/sing-box.log"
    log_path var/"log/sing-box.log"
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
