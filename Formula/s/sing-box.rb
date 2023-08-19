class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.3.6.tar.gz", using: :homebrew_curl
  sha256 "a6462c1c41acfea0ac1c815985e6573dc92895541f75f678c805203879421927"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb23b3bea43432fb1f7db416da32e17833e4f8d5f60cc8fbdcee27b9b28b530"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb23b3bea43432fb1f7db416da32e17833e4f8d5f60cc8fbdcee27b9b28b530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb23b3bea43432fb1f7db416da32e17833e4f8d5f60cc8fbdcee27b9b28b530"
    sha256 cellar: :any_skip_relocation, ventura:        "34a5715424405c44f792dab158329a91246cbcd533f53455f653fd3c473124a0"
    sha256 cellar: :any_skip_relocation, monterey:       "34a5715424405c44f792dab158329a91246cbcd533f53455f653fd3c473124a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "34a5715424405c44f792dab158329a91246cbcd533f53455f653fd3c473124a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d991acc5635c20eadd4eeee1c93856628b9b055d7de81270025272158ccd3b"
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
