class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.5.3.tar.gz", using: :homebrew_curl
  sha256 "e050f8a588d92547ba277fc8980af8ede544c345684c20e4b008fbc1b1371fb8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c796543ce3de0aea63ed6354acafeef4add9d3c4e6b7439f9bc8bb2a29a5b7eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d68baa0cc5c2841c78bc8389c13164f4a903bad44d66eaaded9983fb6b566fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f897f4bacf2cda35b647d00fe87caeb52f6fe58e4d37bc49b1134e0c23f8d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c35b75c4abfbf0ada18ccc81cc3fd9cfc8d8b44bb3db704ddd1af2dc87f78c2"
    sha256 cellar: :any_skip_relocation, ventura:        "570a022317603fbe7dfd9c8f210b2f54587f79243ae7b53e6aca55258f1cc93c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d8aa517e848fc75556db2fc01b391915533b90918f6431a631595bff0820721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc89c322aefb94a7199e96f8c9902b8f141cc17aeecf644838825ae7569f225"
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
