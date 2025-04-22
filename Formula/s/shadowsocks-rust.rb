class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "0af223694de7261d4cf00f49e34f6dfe9ea5385bfe52e64f96cb0d11f3b947b0"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924fcd0a496e413cd6e1db0200281d6b4df05ea1edecd83538e824d9975bc9f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ff08700be08f86c972d71a8700233b851bb71887e8e58061f7f094439a6119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64e8754f5692a56327e5002a684ad12e6ec47ceb6aa25d02b2ef979b2809f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffa97bb54ced8b1aeb3f8433b90607a1a66437f9ff99e238599868d1a156a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "627262b2357638bc6723bfad9003f3e03dae77c15feb4b6154f4943f7e406376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47ff281e6b9bdb4f04cb8536eb719aaa92cc5d72c99208b6351b797615f960d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07816828f1d33b7d2c43bff2fac295b1dcc1948bc49300f90f612a8928b3602e"
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
    fork { exec bin/"ssserver", "-c", testpath/"server.json" }
    fork { exec bin/"sslocal", "-c", testpath/"local.json" }
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
