class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "e854743ecef9ab3b371fdcb139e6f4452831b487d449c97c2129abbf4f51e863"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8297bfbb3043d0e47db5536f1bcfae18216ffb49e15bad7c4fdb5a8ef3cf0edc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7ae4f6b86f003a119f0dd37ac8ad182860a14409652cacba9ef31edc990280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9c0b6c454c72a2b1d62b6bb6463eda8268cb2d830c255739d63b3584eb22cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c81aab449526736b32f18f9692c08b02dd85d8b5f8962979255348271456060"
    sha256 cellar: :any_skip_relocation, ventura:        "370403868d94771b57ee03934d65f9922972f9be1c22b229cdc6d40a8720e260"
    sha256 cellar: :any_skip_relocation, monterey:       "e048b32201c8867adbf685daad2f5ebe104a0e48fe957e28f66dfe6442839682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f50a1a9aa18de3fcd208acc1bfde6ea2dac95667c415559b39ab9df4ee2618"
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
