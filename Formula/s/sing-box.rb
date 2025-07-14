class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.15.tar.gz"
  sha256 "97d58dd873d7cf9b5e4b4aca5516568f3b2e6f5c3dbc93241c82fff5e4a609fd"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5832dd0baaef2d442f873c1a6ee6e3b4f7641954461d98ca38013dd521356690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef94fdf5edbda1ddfb2de0e8361e2207ee68088451469078c415258f00e5098d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87c26adbabdadb465f5f6ddb584eb5528291da88902cc009b5c43a9309dc7525"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ce58937e4a7e57aff87fc11bebdb9f6bd2339b20fc16fed0f8f01c01685152a"
    sha256 cellar: :any_skip_relocation, ventura:       "0888fb16fb3a261e3c55977aa41b5d31f1492dfba9b90dfee8b2ab7eafb6e896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab0a544b28d845df3a67bcfcea9c6cc26e2a0fe60e3d2edf1e5e900c3388e2d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_dhcp,with_wireguard,with_reality_server,with_clash_api,with_quic," \
           "with_utls,with_acme,with_ech"
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
