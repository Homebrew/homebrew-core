class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.8.tar.gz", using: :homebrew_curl
  sha256 "dfa64c1da309000998ff9c5fb35bac2795c9e88ce3c63ad47862ba6c3aeda74f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "208a713d41cf1a4a267605e2b4811c345d03a2bdd215ad1f6625055e72446533"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "418a3a677dc7616fa865a50584749f70f4014b7603fe48e89ee5888d303d68d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0499e9ae7a796a3eef7da85c192419269f95e3d4d0b26ecdb9edb2d695f2e56e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e937cc269bf17aa4d11cdd5f5e27d3cfb9362c852709e231460db69064ef2a5f"
    sha256 cellar: :any_skip_relocation, ventura:        "d9e412e00991934563e1fdf14922ff0793fd4ea53809050daf856a92a290fab0"
    sha256 cellar: :any_skip_relocation, monterey:       "df4099001fd21df0ca10d1cfcdfa2b431e58bbbe7126214c2f86c99bbd3983e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5c666510a6a573f35bbc32275668f9f23f31edff2ab39902b9a9bd8f25387e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json"]
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
