class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "402b618148b58f5ff6c1bee4f4fdcf7cdcb88a2df6a8bd682ea742a89b5be9ec"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ecee7983de97cb39612dbb93db5ac56b40d74109f1edab207c828402dab249b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eaaa19e817f05e5707609a0be0a87e7f212ec25a10b8cc615407db6de1f1bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8286d92fbf9841f5572df216dc16ef0071514b1c3d4a1561177f2c6ca92dfd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "187e85a73a76b62de48f4b3581827d2f4a6e9f625d6e614ae6570aef046a9f58"
    sha256 cellar: :any_skip_relocation, ventura:       "b952e2eaa95e01b3818f64e49cc3131fd561035496396c46ae76e0abfa56cbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "381593d09b68a25cea516e630df96321cef64d587927487176c1dce62bf8ca11"
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
