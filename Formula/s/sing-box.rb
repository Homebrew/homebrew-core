class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://github.com/SagerNet/sing-box/archive/refs/tags/v1.12.17.tar.gz"
  sha256 "37188348531f669ead897afc8a2e96806f2f94150e48a78d2b24edacfd4f93f0"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "dev-next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef55573cbc649d189771b1a62cd825633eccf05d7dfc6d61772a214489679c90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6ed259799902bbce22844338581fc49ca24c65492a783cc4b034cb305802ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "156d3ff2fa8491ce34a4b73c41670f64482f43a68c47f5af48be2f448c771b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "29755b84453116fc7cea4681826eefe54b0df1ff1a9ef82f0913c6d549a878d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0616c88113dc9c3ffc4b814da4a9753c3e0c00cf377ee77337ce995354cb02de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0343ddefe3b59fcdf9b74afc88f3918b2836b41e8655b4662448b05228990da"
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
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
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
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

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
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end
