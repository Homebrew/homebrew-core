class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.11.tar.gz"
  sha256 "31cc321efaa2fe9f3e3be9b065354552378f5a1dac49f6a24ce7e48d8a6c8979"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e614ef31a63a5ad8c66bd63a99c92fe521bb276110625591354b3a4d2b004943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456d9d83214a7814ca33f91b4dda4b8418bd68d7e1f5b7ca411e3a4b5dcf9ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f0a00c0eb31ac9c224abf4872fb48c4fad1e9e39018c5c3a18077a4fc3d7c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b8ad1975e095e1e0d397b35610f8d626f3d760a98302c84b04b843996d3dfb"
    sha256 cellar: :any_skip_relocation, ventura:       "d0174842a207ab6c789d838ba3a15504ec169940a7182d5a1e683a6da447d452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb6c95e210fe750d8655672c0de2465f2d815c91ad0ac27fc8690e3b676eba0"
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
