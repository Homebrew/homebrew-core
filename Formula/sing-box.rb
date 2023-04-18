class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.2.4.tar.gz", using: :homebrew_curl
  sha256 "72dd2f358ce17605e17862be8cd34b84e150ce505f08d0d75af50c5cf5a23c29"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe8eba9ace96e6eaf5599528e73c06072181596010de7d200adf1e4dfbe788a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe8eba9ace96e6eaf5599528e73c06072181596010de7d200adf1e4dfbe788a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbe8eba9ace96e6eaf5599528e73c06072181596010de7d200adf1e4dfbe788a"
    sha256 cellar: :any_skip_relocation, ventura:        "f5796ac4b856af49503005ed91a9185531839e97cd77643002aae07410f4a453"
    sha256 cellar: :any_skip_relocation, monterey:       "f5796ac4b856af49503005ed91a9185531839e97cd77643002aae07410f4a453"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5796ac4b856af49503005ed91a9185531839e97cd77643002aae07410f4a453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b78a23ba9f773923dece28465b9a31d5b65a0562da02a4223f8dd543ba9579"
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
