class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "4d3da19e0819fdc12740539512dc3455ea030747c2fa04171967715fb26ff775"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e08782c153a71f48d5b047fc3ded1110d8fd96e3cb76d9465eb408969b30cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "790f14093f1c0233a968f51b72d1b057f40f489b4ad650ce47fa82e697fae5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327595b7197c9c8d0547da33d6715fa528fca0dbfb5e3852eacc029991ca426b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5bd1f28073b74b33e90ea90d507d18944215c6c6f42bbc6a5e6ab681a90f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db0e8761832eac66eda87366febffa76a8c810aafd76799bc7d9a9cd26b2ec5"
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
