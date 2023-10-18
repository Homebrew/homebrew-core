class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.17.0.tar.gz"
  sha256 "ef964ac60a499a0c8313d48284a7542c085f9c7672eb121a796b70d49163f35a"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c6293f56f28dccbc4f717be4b73fd71f2529a4e034ca4975dc85c730009725e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a7fa91ec79ee2e93dae57bfceadd58385837445ecb0595b34dbdf525fb15fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ed6fc02e44c0200ab331a3ce2382f57c988cfd1d90890f1f5b03037bfc8fe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "592001ffdf4ea33051dccf3f56df151cd87cd355ca85871baa72de76051b3c06"
    sha256 cellar: :any_skip_relocation, ventura:        "836ec52572b1370f8eb2c6920375a8508fec3265d508dd36175e181a7b29112a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ce717bf2a9cefcdf84cc7c0149a46d303aad5cc4e59eda4e8442aa9c836881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3024ce478452536488dca2688afdc429a0afd28bc83b08e1fb85869f3032e315"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    EOS
    (testpath/"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS
    fork { exec bin/"ssserver", "-c", testpath/"server.json" }
    fork { exec bin/"sslocal", "-c", testpath/"local.json" }
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
