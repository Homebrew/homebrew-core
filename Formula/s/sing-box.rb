class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.6.tar.gz", using: :homebrew_curl
  sha256 "b1fcb8c953d2bce9192671545c44e92a733ffe17caee77749d500300b258ec04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4281424f166270889a90992880609149545f6555d5f5f5a3029fd78b4a3ad92c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d2cf01cef5b3ad5a7fad2232eaf286c3d6390d2b9ae99f55e9f65e32c8d6ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5646b18e73208bfa540e905c47b77bb5ce23da8ca6783291de3ff82c668de15"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd33a72ac3423cbdfefaf7d132fa69eacaf8bd6e1ec22c2b621cab2525fc71ae"
    sha256 cellar: :any_skip_relocation, ventura:        "50a8f62a2eed4b92c71575b71d4fae1b91c71a38f1b6860e91ca60fef8452dd2"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfb4f6cfa7d34c414c16eb0b34a846e9ef485d6569f0a8d3daf3721d1953000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fac53d0371586a7bd2a338dcf4c4c11cc4a3d14ab89ef296daedeba19c3af17"
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
