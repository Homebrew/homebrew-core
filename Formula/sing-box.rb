class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.7.tar.gz", using: :homebrew_curl
  sha256 "49b829f4cf148b59789eeaf8d01987e7526a44d0290cf608a6350c57562ae177"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c45d660224c148b908810e826acacdd4b5d21937d344af232b130a33f3d751dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c45d660224c148b908810e826acacdd4b5d21937d344af232b130a33f3d751dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c45d660224c148b908810e826acacdd4b5d21937d344af232b130a33f3d751dc"
    sha256 cellar: :any_skip_relocation, ventura:        "32f82f05a06f828cb434e96904bea183e805cb3556576c6304d10b1b02e6ba63"
    sha256 cellar: :any_skip_relocation, monterey:       "32f82f05a06f828cb434e96904bea183e805cb3556576c6304d10b1b02e6ba63"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f82f05a06f828cb434e96904bea183e805cb3556576c6304d10b1b02e6ba63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae6ac1e5a651d4349486357c9f2c6c38219480dfe67c6b476c154a8f5752c57"
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
