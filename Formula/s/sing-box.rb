class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "5b015352f3434bb780af01a6b1f6c0fe706166d6c44a69547e29892f0920b944"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0c3fad04156536913923598d8be9f1e58dbe4af3db02862fb38ef163fef5cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723bf69007ad133f5402bab05e6321acb9f5590d34247d61c933afa141650971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed53a679aff7836c27fd550f14e8f6cc5043866cda27e6954f8a7c9fa7be9ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3cc509019a4b0a1a2c77698e5464c5496649d9f1a26b3c0981aed41d38fd0f6"
    sha256 cellar: :any_skip_relocation, ventura:       "2c9f49aaf22185842dd5db717fef0aefe6d172125d0f5a6390773d61e10fb633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94ac0c51446320b728f8c81d00c74a016635f18785bb47e5d80ecb16945bb87"
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
