class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "7ec6bfe18522f34c0c53aad7b2de2e1967f66c4091baf5674acecd78f0b81aac"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5257bff63d6c5b1f4201daf95a2789ced6b52cb3a512f785fdcbe57352f0ff99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38cdf648437d12763cbe0a002440cd9e7606f672ac815ce926b5452ee306432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ab3b1c79aa039aafd86937ac8b962a43ec339ae195811121b1d4042145e1868"
    sha256 cellar: :any_skip_relocation, sonoma:        "0281bf6b3ae12b1be6157daa9e65925f87821a52f463b2f98b0a60ddde9d3c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "351d003640a723881c4d442986ed3dbfc1cb22ef5f1eab4daefae98a1887a488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a54d9470e6096f20f82714643a9fd8104bc896ab446b6c2e41ffab68e6080db"
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
