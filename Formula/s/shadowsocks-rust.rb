class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "c7b8176db50073f64650224e7dc49d2aa96f8871a99ac8039bf7ea38eca82528"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d639aab616efc31c6e24c2e20ab0f7dac343eff0db45d5a106e8157155df8db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc06b8097f9e09357fd520648f7c0a777ae2443a47b9680fcfa29a530276def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "973f6f23c1b9f3a5dfe0c7caa6f4e7881517976ad46a7f3127c59cee6e2b08c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "59ff16bde1c4536ddd69d05d824e04fe45915be8c3798514fe307e104c166543"
    sha256 cellar: :any_skip_relocation, ventura:        "ad31e8c7e6b47ebcb1c3139d9244a3c85d2e8defcb2deec35148d4160d9f8c02"
    sha256 cellar: :any_skip_relocation, monterey:       "61c87aa211fe9998b7680ec4e18215d6a19080ffa024e84505b4eae3f171f6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2f9fb18fb19dc2f6aea9566b6b00a036743262f7ef3c7b43d068586555e522"
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
