class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ab3d321860f973151e773c0c4a1478ab31ed63d89e17c7ac618cf50b232dd1c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "010c94e09c29476535780e6b6a891a65034a0e17c5672ada9691c9562270440a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f00a1346da4156a874fec588bfc233a4027b02e02d08e5e7acca26c829daf00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baed40a2ee60b93a4739ed318c8ca925f10d7bbe827276a7d719bcdd118da3db"
    sha256 cellar: :any_skip_relocation, sonoma:         "59304a17315d033c626a53adf0a70f9aa4a2defb8b46aed379fd48a868575652"
    sha256 cellar: :any_skip_relocation, ventura:        "90839c24aeb8012ce1283f31b84d37ad80fc29dc20925d00452047489861b551"
    sha256 cellar: :any_skip_relocation, monterey:       "efb7163722f368b3539aeed5f9f26dc97127041591c6a7059697daeac998caff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d0a12edc5d900b21dbbbff5b3115cfbcc397ecc8039c5e3b03c4652ce3c288"
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
