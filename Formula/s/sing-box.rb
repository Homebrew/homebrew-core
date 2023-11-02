class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.0.tar.gz", using: :homebrew_curl
  sha256 "3272c9ac447d009749429f38d76e9879609c0c321442c3235ba806d995c0838a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "983e2910613229dd6e60612b113776e3c4802505a37d743e1c073ad4e86dd244"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6585275c332d5dfc63f2c6efae9a7fc3d2e61bfcbebc781b12c7d951342b65c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6faa2f92f33aa744804447ce9541e1957b4f05fbf28b8ba875bcac1984b5259a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a64f6d793eb8f2b079805df931d4322ba5a93496ffe30b9c51205029583fb910"
    sha256 cellar: :any_skip_relocation, ventura:        "c60d092b54ea1bdf548bdbfba9ce2110d56155dbaf6b63ef9988f8e090d05148"
    sha256 cellar: :any_skip_relocation, monterey:       "233759c288629f9fa7b66e98dab1c5cca654db9b4901908f64bb1bb0513396e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa98687b8168f6028bd0fb8e77a36222d00151d5b7e48e713e84acb5081761d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
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
