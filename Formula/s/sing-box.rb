class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.13.tar.gz", using: :homebrew_curl
  sha256 "de1c09d096c6fca9f59863a051438aeb3197713faa6518cb46d7ca0a9bc63976"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3edc9f6b363d419cad1e2693b9818d8891a2cbfbcc28f6548ebc4fdfd9a0679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42a5b5d8fd4066e51e0a55596632ffcff77dbf37ef100cc11008d9b2e1f4c7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26cace26b952e1e638ee8268c2de0a4eafead100d9950d19ff6c778743f9f041"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbc2ea020cf8ec4d83c2f654a085307c2530a4190d26df3cffadad6f2b0ca225"
    sha256 cellar: :any_skip_relocation, ventura:        "e9474392029cc8fbc70af0b5bffa8e7623b724b41f15935071e096472e7bbc53"
    sha256 cellar: :any_skip_relocation, monterey:       "3d476595c23154850107e247a45c5637a9c046a9bb86f27ca5bcdcdae4b15790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da643f1a0223b5e1b35e9999ecb7764befa11922bc62eb567feb1114d26f3a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
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
