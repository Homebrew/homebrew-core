class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.16.tar.gz"
  sha256 "a25e579dbd4ccff388abd69c7a63d73851a2c24225da436df1d6be05c1383966"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ed2da4792fd1e74c26d01c40c4ef669ce99f92503f6a3ab83ee543f73af469d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52300aae28a4a391874ff9922565442ff418c03d4f0355b7d5c5551d16b7551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fff5ae994c611677b7381715839de5237392056cfcd20659dfc4d8a920030110"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8bbf8f74731605bcf13617430ad96bd0d0000d5c180bbd39532096721c98a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc190794b99394ce002191f862c14ca46c1f3058c6af0b79b80b3f2402ea0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c5a00679fcc60ef9090811f2e9fc1bf4b35740185b0a944058d02d9dcc1cd0"
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
