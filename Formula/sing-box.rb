class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.3.0.tar.gz", using: :homebrew_curl
  sha256 "19b83d9cbd4e241da2ec9cb14110826b2694590950356a4f4051081ec4b4c92d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bf7ced093e723acba681e0701010e38a5844ba431cdbc7b22511d5d460ffe89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf7ced093e723acba681e0701010e38a5844ba431cdbc7b22511d5d460ffe89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bf7ced093e723acba681e0701010e38a5844ba431cdbc7b22511d5d460ffe89"
    sha256 cellar: :any_skip_relocation, ventura:        "257d0c15a802d29bfd94486b5b6dd141e61515f329eb806b8dda064a725b4c10"
    sha256 cellar: :any_skip_relocation, monterey:       "257d0c15a802d29bfd94486b5b6dd141e61515f329eb806b8dda064a725b4c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "257d0c15a802d29bfd94486b5b6dd141e61515f329eb806b8dda064a725b4c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa1314080d5c4e83185b76ac19a7c1f4740f631a723ddbe35cc92db659c83ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
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
    server = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

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
    system "#{bin}/sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec "#{bin}/sing-box", "run", "-D", testpath, "-c", "config.json" }

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
