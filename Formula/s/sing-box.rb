class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.12.tar.gz"
  sha256 "f08add81eab7e4d6091195179bb39fa3f64dbb0326feaa022994566b702d1245"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0403adc6fa07654ccff11390556022b7c579ab094f7b09dd1d2c22bc47f15f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbcd1cda18adc51c5a25bd914193436ed8e98553428795e4ce30ed2f8d0d82c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a649b3461c20450bc9dda444a9e1723cbd2c7b6270a1986f329ea218e1b403ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "1046e37866357d263951f833adcfeed461c136b3e17844ff7729e58a3a659472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b947a0d0038dc7eb4baebacd6eac75710c192d7f799e75b8602f652428016c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cd33f959984ee267288007faf68a373b14b74917cd2f0adda3f5ce5a9286248"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} -buildid="
    tags = %w[
      with_acme
      with_clash_api
      with_dhcp
      with_gvisor
      with_quic
      with_tailscale
      with_utls
      with_wireguard
    ]
    system "go", "build", *std_go_args(ldflags:, tags: tags.join(",")), "./cmd/sing-box"
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
