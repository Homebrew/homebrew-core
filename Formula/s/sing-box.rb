class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "4b98ea2aaca33ac155fe90ed0f8303a46c567fbcdd44f7d37bb26db85a7f70d5"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "615cb37870bd4671cb5af78efdce0f4903d14256f5e7f7218852361b1dc0dd78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8907353e8471f8a5333acab172d259e7b747b20db27b361178f8336fe7d35579"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b67e6a535777d6ba22fb49acb6e79205acb4c54ab4838401ec768194e1bee975"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13f8374e8ca4f068326e55e44e5e5b6edab2a7759481cb58bd1652d5904cb6b"
    sha256 cellar: :any_skip_relocation, ventura:       "18785034d0b27af967fed4a1dbf84d29927b1a4abb62edf70a60c8407593b780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324c87eddb099a3368d36a2e8106a466fcdd960ef2ee2a7371cca3c493eeb884"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", "completion")
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
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
    JSON
    server = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json" }

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
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
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = fork { exec bin/"sing-box", "run", "-D", testpath, "-c", "config.json" }

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
