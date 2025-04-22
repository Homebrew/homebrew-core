class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "de797c9e848c9c3a6f99cd779b442a4e856a7f267e514cfc8169f95baf48dadd"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf70a44fca457240fde3349f5e2815407aecb4a43dbf903f5d1168cd4edd0c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb399541ea132e641fff272d4acd8d5266cea2a83128fb678fb175d38fc9ef9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a141ce719ed98ca369fef0d5a6e08bb7b3125379f9ada07a1c22f281566da2f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2963fa35ff049263b2470e3cc42cbf0eae3a80719ecba009f739c28fcef0402"
    sha256 cellar: :any_skip_relocation, ventura:       "b02cab80dedc0b80aeefd70087ae35142fbe81645ad958b1babf8611eb9004ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338ecd414e27942cb92e3d1788947a13e07bb5a85b7a331b2964efecb49f2f97"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
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
    JSON
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
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
    JSON
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
