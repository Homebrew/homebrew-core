class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "2bdc5bbc12e43d56f558458b22394d285bec5d0c98e0ab31dc3d74fa2ed6a195"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3533e7eb598869024b786a4834940fc19a9b703134d24e0de6f151b81465ff78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e31dab6901acf0686feac16723ce22e00bba9d6efc62e9ef4a8515a695473b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1475fd2acc8535f46e046c0d7babee9df4f5bd0f27fe40389cdd888b17bfb6e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "01171e69c2548858eef2b33c33b50c5b31c7967b12caf1dab1e82f24f0a7d4ee"
    sha256 cellar: :any_skip_relocation, ventura:       "c96f6dbc5c79b0b82bd2e1f0fd9e666543c1cbfb09fd3083010b4a130ad0eefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fadf5db5a9080ff3c297a27b1d485f3556ce03baab467f4deb898f8411b1a0d"
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
