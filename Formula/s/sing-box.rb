class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.11.10.tar.gz"
  sha256 "b79281cbe1a9585bf53855ebc9513ccf2fe772983c4926554389ba0f5598da3e"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8be95135471213f4a1bdb618db32fcedbe9669a5d41bc1e8fab464663b0f011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af884d2ad8bb086d6380da158c6bcf84d20b156c92a8bcdf4c8cc41ccb7e8e6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60a66098bb4dcec863a39e6b97a53a7f5c34f657cf39fa80f539f9fe47d5187e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc9658aa88c69f23655ff71e301c7077d0ec0e6461be8d294e99969a811a85a"
    sha256 cellar: :any_skip_relocation, ventura:       "c2fd3190c0b56e9ff177cbc6a7fec65ec3871514728efcf1bc9509c5d6728aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a64106086c79c5d1b7adbcc44ec3a7a9c5ead4c20642adf2e65c171abb5c9b1"
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
