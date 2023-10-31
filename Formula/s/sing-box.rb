class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.6.0.tar.gz", using: :homebrew_curl
  sha256 "3272c9ac447d009749429f38d76e9879609c0c321442c3235ba806d995c0838a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b7694468e7f7db5124cb0c1c38a5a80e37a7e80612aa0ac201a6196b5f1323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380f83e2a031f23d197e05a50c82d67b2e26688a58070c070259300ca71a71ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e397b9043fed1f82c139494a481d9f3080398d9871a8f4acda4bc9cb0d54868"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a9b2229670b58068b941e2d3eb1a00272882b1c0a29b9de36cdc99b12d0507"
    sha256 cellar: :any_skip_relocation, ventura:        "7ff6a1080d2f90e344874e798cc6f98e2a2ec86e7ce21b825a6d2e06d0ae4081"
    sha256 cellar: :any_skip_relocation, monterey:       "f78dc4d072297104607ee61be8a3140f4748aa571b333ce36d99b1f161665b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bae5cf510d63765bdbc8775975b7c0513707128e2e581d43d6fe75eeb438df0"
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
