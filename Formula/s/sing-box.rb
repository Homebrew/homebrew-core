class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.11.tar.gz", using: :homebrew_curl
  sha256 "d6c33792c694b817ac86c9baa5d73a8112deea341d4a36c83fe782efa8bf3548"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3cbd0c15ab44683b020656198b5d7ebc5e99a0dcb60dc6edbb2c189eeb65b9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8821a2aa2aecfabebd5a35c4de3397f90ff922c94a8bf6a5d38bfa66c5a0f3eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db7dc519aa614fc24e3a0b9dc6e34f5f9099910d4aa6d8f755bd146b2478b18"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fb77b9240df16ca92281bec04f0a55e2db41a0992451946d56d569b54acd1c1"
    sha256 cellar: :any_skip_relocation, ventura:        "06998e6da6d673ffc8bb26e9915c4bb524d11148be56ebaa7358f6d20452fdaf"
    sha256 cellar: :any_skip_relocation, monterey:       "73a2ff7e34d86457763fccdd86cd06c04a1018a9232dc7dac9b87d428308ae0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2ceff76d72263080f50e81173f8292ba1e48070021c1bc454ffd14959afa7a"
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
