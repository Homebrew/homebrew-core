class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.10.tar.gz", using: :homebrew_curl
  sha256 "a959f9a40148ed4166b8161072672f3ce1532957adef7717132c7277bb96dcf6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffa25845bae04db47242947dfffd5d2b8c54fe81b6fd262d4087a36347c29b63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ff2897cd828983dcbbd85975324ac5a2616c421b4687e15cdd529864067c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ab971ea9d5abf6c2838fa52101f66e359376b0909c3488a49a2fcea0b38a1c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "96e6e5e70e45fcc867badeb131c27da53cc5ba8be0e599fe3bd66ba4d66f7471"
    sha256 cellar: :any_skip_relocation, ventura:        "b92b19246f1ca375078dc0a3d920033d9fe10a5c695dc737fa5491817d5dd51d"
    sha256 cellar: :any_skip_relocation, monterey:       "76777f28c99ff01f4c1ac696efa6cf1e7fa2ce313c09dde876aa0a5d1cebc0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4163772f1de9f546f599c80becfc896f59b650213cad53773b96933fb9c2be43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/sing-box"
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
