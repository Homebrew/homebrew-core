class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.15.3.tar.gz"
  sha256 "13b877b0961402310f45b814b1f4cefec141d0a2ff8be37d57f1ee966c41c497"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950c64942bc761e1ed5814aac1868f6504c6464813eb324d366eabd09df67867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c326eeb5c86e5111f797ed1aa340651a9297a2e8caf6ff2ae46ec6975f2d7a9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f3d23e6135f780a14972579dc3349fe58960649bdfeda78d72a0afba6f391a4"
    sha256 cellar: :any_skip_relocation, ventura:        "59fe7897586e80d2f741e2d2ff1d1995b5b4c6f9e2a9ff5d390dd178aab4dc6a"
    sha256 cellar: :any_skip_relocation, monterey:       "189d87b939f0c4a84aeebf0b4883c2f063e7c40a00008967abe8f80f04a6a1b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "85c7070712b80316e640f758525b0647a10afcfd5caaab3dcc1ef1091d99c585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb87666aaefbd22b44628a3c9151e0f062d540098893f63cf7468bb14760ff7e"
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
