class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.2.tar.gz", using: :homebrew_curl
  sha256 "ad344a5fe0a515e3e5d0ab8102482b4a3d38932cf754756e1d48db17d36a5609"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24786a6c9f59bc6ab2a3e257eaad6d1d7ee9c8f96e4081038a2a32f1bc7b0d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b08e32e392a8dc173bd8c92ece29f1ea1f198166c22b30820e4b2de93a5010ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67cef9ea32a739b4ac0e362a74691b6163d322aea111b68c39e851fa098fa2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "567facd174c0027a839bae4172374e0c2168253b9bf0ec3dcc956345a85a3415"
    sha256 cellar: :any_skip_relocation, ventura:        "439d2944ba1d52096964673a327bcba4af76dea00825c4ac686474cb60354350"
    sha256 cellar: :any_skip_relocation, monterey:       "dac6b64ecb0c93b7f3d839df20c001dd09eba6d8ec086a64f50f192633aba63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533df11da1448651f4beaf7f8d23c020fc63addc55360a14f94c7a8a775c2a40"
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
