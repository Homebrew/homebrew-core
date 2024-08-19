class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "30652ce0151ef46f314b25df74b402278dd7c540ba0b7f1c2c66209314afad09"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "005318887a5478b58a5a9c2556778a1d87058cf3b92e240c84ef77ec602e028c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b75a6992207042cb65cd3d5cf6277ecd0dd8010f3b2a82ce1b7fcaffb8d35164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf7c1e3c84a642a75861dc0af7c0e7fd4eb445035d7355715dcc3645067d5ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8e44e7ed928294e69780826bb6720aed6697763ebf6a60830453b3f6748a713"
    sha256 cellar: :any_skip_relocation, ventura:        "cde5964494253b3ae1091182f54149d5eac9a74bd76ea17f2ea92753917f95f3"
    sha256 cellar: :any_skip_relocation, monterey:       "844f956a5148c7873d503ac925d390fab8e93ffafc189253c87ba1fb0b2aaa6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482e746731cbea661113694af6522504d22fc0d4340d0f16c3f884e4a8a97a4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
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
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

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
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

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
