class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "9494c869dae92d1d4b499226c99c606ed7cf80eb17b2e412ec5f9d9deac805aa"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82dc3544994fb29ef947bb71e9f4177c18de3335c79c4791bbcaecb032d76aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811febe1b5256f96b8c9c9126a25a71b73427989e21f9f7575ad76a6dd399ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f85496c883beb0cd312f1bc4caa5cdd1802f248a0e546e8512809ef072fa5f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "146b36638d810c9e2d32b046e7605725b0ccc502339ab5cef36235987ea86241"
    sha256 cellar: :any_skip_relocation, ventura:       "a8acf55ef192e9d2c16b4b1c7fd1b32ada868e2b46cb8991e7a2340c0117b1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91629a5b027e81ac93617efd833c59938145c341d3b301f6db387484e307a6b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = %w[
      with_acme
      with_clash_api
      with_dhcp
      with_gvisor
      with_quic
      with_tailscale
      with_utls
      with_wireguard
    ]
    system "go", "build", *std_go_args(ldflags:, tags: tags.join(",")), "./cmd/sing-box"
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
