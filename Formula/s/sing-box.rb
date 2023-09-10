class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.4.1.tar.gz", using: :homebrew_curl
  sha256 "5b8a576639e24640b76f5ee175aa83a54bf9a68f3a6de1650c3067f0f0405e7d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67c873ef8edbe1a37236c329ab26bef4084d5b669734fd5cd4955c5d55bd267b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b124ac80d3b14c102920245f55fbe97829a233927468c30466dff7d8646062a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39802348d894e802b46be9a2275a61bda7bd1e2f15acdf42519b1d72e77d286"
    sha256 cellar: :any_skip_relocation, ventura:        "0fa1b23bcf7f5e55f0877415a367d9429f66a4539c8d3359ca98bd5e6d720290"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc3a50a7a3c7e58c352e12c13968b7bb38df314282852e20e5c4a0b60ba89f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d4c59d808f2a77c8e63bf23b8faf2f3f94f1a55f5dd60b642655a2767e4c0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9261c729a0c7be8feeb070d22d93d9c052dffcef8ec7cb3c2135d2bbda5dcf2e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
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
