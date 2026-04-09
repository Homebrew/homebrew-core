class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "a89865d1c5203de1b732017dd032e85f943d1592e8d3152eb7d2c4f3fca387bf"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "775bdee3a1fb92f6d3093376ee7eaec81da0cad45f6ac83f52f6c3fc766d5a67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa7fa8673779951f81de44dd51808712112a9ecefa22651b2bad3db026bbb03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f68dcaca8e3b815453abafb137fbdda44b0e833ecc01a0b9c0e6efa1faa8f732"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd63ec3752d71a8fd1dac23adc25c604d7d4f4242437d24052d8d0ae5d69c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a7e8772935001362f1a54be79bda2cb6d57ecef99a9ab912f5f76c9fc7363c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f889505350c1a86cdc1f4d201c8055aabdfda0167558b95dc7060127d7567122"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"server.json").write <<~JSON
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm"
      }
    JSON
    (testpath/"local.json").write <<~JSON
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "password":"mypassword",
          "method":"aes-256-gcm",
          "local_address":"127.0.0.1",
          "local_port":#{local_port}
      }
    JSON
    spawn bin/"ssserver", "-c", testpath/"server.json"
    spawn bin/"sslocal", "-c", testpath/"local.json"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
