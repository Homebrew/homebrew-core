class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.10.tar.gz", using: :homebrew_curl
  sha256 "a959f9a40148ed4166b8161072672f3ce1532957adef7717132c7277bb96dcf6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1984d8be5110f2b5d2e69c421b5cafb690bb04f27f578c4bf494dd8a58d9ab94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "928c107668755a6c95a6607c17f431135260fffe7e1d8c8a893c207c60de670c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a93487bd024aa25c23c1d46fadc8ef0f14f9a64ba569a82af87966c23e3e3595"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2bde0771655b6b716ded21c230398c11e1b9b45bb632df8f194f1b169489e98"
    sha256 cellar: :any_skip_relocation, ventura:        "e01af3fcb8bead825874470daf7066c693da955bcdedabe9a733f611a3582528"
    sha256 cellar: :any_skip_relocation, monterey:       "8ec45fa074b3761136487ebc88e88fb99f06f3c0ac635ea82fb2629eaba12abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f530205116537309d06c52672bd3c3777a45f2a45c9b68e1c424adefdb046c54"
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
