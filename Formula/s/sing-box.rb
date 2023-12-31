class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.7.7.tar.gz", using: :homebrew_curl
  sha256 "ce182cb2181e898b56ca9b6ce0d5adeaece8e761ac62ce8cde69b3c7219b8430"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c0ce1c3f2a20833a59bb6f6df91580c39e1b27548d507305907c43dd5a0f779"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9d406e788694a16a90a98babd1a5a7a1b47db862bfdc079dc8f32e29ce5273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3059f0a3310caf906189bfeacb3f63166e3ab5f3ca16a893bb762c01d14bcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f2682a126ed7512586cf4af815d513974d0a0dfa8c8cad0b1c7ff677d8de86c"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b83589e42b78a5ab14312d38932c7f862f13ae9b0372744ca942d7d0355d98"
    sha256 cellar: :any_skip_relocation, monterey:       "875c375d8d79b08d34c37557311617bda87f36665f38561d8cae7a8c5c170561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ac00520c058367e7134ea397691553de3c99428720bf50fd2955c6a02e33f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json"]
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
