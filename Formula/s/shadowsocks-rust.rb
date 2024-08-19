class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "cf064ad157974b3e396aab3bb60aab380dbc4e11b736603bfbc8e7a138f6bb26"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1630c13d7fb858d36e362a05bb2f251bf480a33195e659291184589216927af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2d45029911859c1d001de8ca6dfc7393733b63cf0679a813fd5c6ab1ee4c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1352fac425cb427c2da55d0e6e93519ace261d929ef559ebb80b6016c1b3a77e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de5f3417ab80e5b9dc1195cbc35172edc65a6688ed386d44aff3ad75ebf7147"
    sha256 cellar: :any_skip_relocation, ventura:        "ea529229436024527d28323b643dcaa88597a9a5cd62d96fc8c798cc02f9150c"
    sha256 cellar: :any_skip_relocation, monterey:       "73e6c78730f1e8feaca54b00747f6b6e78dabf71816c4f5f87a3c09d1ef40069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a3659672ba3738f5ab1066ebe9394ee21a78d0a69f6f205dad8baadc9ab20b5"
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
