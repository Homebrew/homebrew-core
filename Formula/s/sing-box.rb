class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.22.tar.gz"
  sha256 "6c4333c3f53a07cc96b63a801fdf6c156820d51cd2eb05e44ea78df290a45377"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a347ea96c5c05006d7b7ed231c30fec709c34a0a2099c281c18951f1b89ba3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586bd30e69431e07122a8735aa9d5ab22dc00d73fe262b2da624853ca22c284d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1f248537864ea336a76b7c154bc44c14a4c1e8359e63f59a4da9601a13048c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e0c155b15b8b150464d9512748ab0c63d2def44f277b0773b48d00dbc047f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cd442072fcd6640c62ac29078a462dad98b921f5dd5ac92b9258d99c8c4f66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282d0843918d78ede56b9fa4e2f809efd79156b2ca9a80012befe7ab4264288e"
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
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
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
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

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
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end
