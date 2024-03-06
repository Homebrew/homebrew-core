class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.8.tar.gz", using: :homebrew_curl
  sha256 "dfa64c1da309000998ff9c5fb35bac2795c9e88ce3c63ad47862ba6c3aeda74f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2975fd17a14b7ba74307ceff647b8cd13aad960190faba631f036e206a62ae71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dafca5fb1ebeb6f2aba8cf24d02d4a229974f289fa104cf1c04af5c443abe0a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c4a019e80735d25c537287f48cbd4d34c3aceeed08faf27357ba1417a7cbc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "21f8a5dc7aa1353eea7c6a3d8b8b2bdd9aa948e567c02913d2caf899c97e55a4"
    sha256 cellar: :any_skip_relocation, ventura:        "d0acb9d0465904e8cf0794db68f0c5346b8c76482756d66245e62f3cdf2e123d"
    sha256 cellar: :any_skip_relocation, monterey:       "d5f075651616fce8a87b6c79a1a07c3a55118639c406babef820e2f178b69e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9786133047bbdaf13a24be63cd4b195057943e9a5411c18ed429c0f35ec734"
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
