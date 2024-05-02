class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  # using `:homebrew_curl` to work around audit failure from TLS 1.3-only homepage
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.8.12.tar.gz", using: :homebrew_curl
  sha256 "802eb5e202ac1dd846b1f529b3df9e5d69452182fd5d70f7c8f2a819c9e86162"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "505a87a336742739c5187be7343af96424f84106fa4c1655e6281fd0a326ebb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d6fdcbaab706fcd4ea4cefe68422db10cb465b538d64e2aadf4fc5bab601328"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2a1a370bf021f7e90fbb426fa15c16ca4e81e74eaa69b0c65d4fa8ecd8475c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc5fcb8569fe087767262e2780616414728604c178d01ecc341facbcfbae055f"
    sha256 cellar: :any_skip_relocation, ventura:        "785c3761e49f783439d1705dcf8f1fef37dcd307be6a7e0efcdad6a0fb4df833"
    sha256 cellar: :any_skip_relocation, monterey:       "f22c1e5cc668281e740f04058bf8766af320e3cc668fd2d3bc02ddeb1a717020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36552df0e6f692339ad3b0519deb8a14b2b4f49937696c3b93bc2614cf979c3"
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
