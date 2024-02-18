class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.5.tar.gz", using: :homebrew_curl
  sha256 "0d5e6a7198c3a18491ac35807170715118df2c7b77fd02d16d7cfb5791e368ce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88e79728eb8e81e97206ced71675f001686a52fd54a2161be797f2b24bb31148"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5612e46d3e8c8563eb1776b252c001408aad4aed1ee2bb7fbe5d2012c4200a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee969fcdb4f42f2486ede45de7f48d8b6d220a2a244fc9e2a0bd7a357c4c9ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a0b84ab52cda97acfb4101ae0b4dce25f093b9501739caef1f4d6ac5a2b6b79"
    sha256 cellar: :any_skip_relocation, ventura:        "b99075fa0b0e837968e504df4450ce6cf1b0e73d1a3b460702c8404df315be50"
    sha256 cellar: :any_skip_relocation, monterey:       "4976cfe806de58f6703bbfc935cf8312f04cd7e6c8888ab0a6f7c9c4b3247ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de82ebe8b89f3323f6320ab782f7242e0f3a8d682dc7ee904f062c9c836a702"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = "with_gvisor,with_quic,with_wireguard,with_utls,with_reality_server,with_clash_api"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/sing-box"
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
