class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.5.tar.gz", using: :homebrew_curl
  sha256 "709f95d1d187d7347b50cbc986bf2d67188084fa33767da57a520a5ea904e565"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b55870e2a5953eed38a5ece0055269f42a030f416c45fddd64fd3f8649064588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f93c1ae361bb944422559b804b9b85e18b5579815a314a12ebcd44ad3552e85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d9541cbc25e1776218329bd8549cdd4969990c31dfa238bba93f3ade8e8bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd5a7c985bc1892b24a65565ba203ced78cdac6cb230191c9bf9512797ff5178"
    sha256 cellar: :any_skip_relocation, ventura:        "b7434a65d2c733db7ee1891a30912797563f0675e00c55e92c5923a37e2e16f8"
    sha256 cellar: :any_skip_relocation, monterey:       "45256d1dfcec60d648b00d836cab196faae530e3fb4eca90ffc1b8d7acded386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c9576137f02934c6e3f6ed51360735283b6a584c77b298fda908fbefa52de1"
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
