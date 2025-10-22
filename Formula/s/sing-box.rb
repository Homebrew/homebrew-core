class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.11.tar.gz"
  sha256 "14f5f106812b9e0c0c91432c1a6dd0b42d8bcd2fcf3789e4ceba0892967ac41e"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0cef12c9ef545caafdbc7d5404c1a7d5e088b0c6105706724e58a71b6ae3ee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc41644a238bd5f7b2078cd71e928ddb069b7534716359f444db12eb0299694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7129d0ad1073f9f7d715f3cefed67f2342fb3735c21b9c4ec5c44bd73718baa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6226fd8abfc20dbb1cacb25968ad62846b8997bc4e636472b60e2838f10234ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1024b22f66f24532e938d8bc9fee72f25b467168ddd373af921e40159f6a43ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a3a895832ba81f71f2eca2f767c5b9224d77768494cdd86305cdb89db45d35"
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
