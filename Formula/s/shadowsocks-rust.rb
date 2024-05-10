class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "0eb817d81e6827e65593c67d4eef6a1136ca84a1c33cf4c97b3a84e98e5a7f60"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2a7a903d39d2923ce0c8c5bcec521471fc20259f9664c27770454c4ec421327"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5007a17b8d0fcf9525cdb423823548b665cc8c483297bed6e5a3b2e140ed2e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c2cf44a8bf2d72e86e2ee250c4241eb9ba56ca4756d1969b9aa53d9fc4d6df0"
    sha256 cellar: :any_skip_relocation, sonoma:         "17712a7206646a46f6e387b32f16f84b810bbfe8e490a86516d1adfffbf29569"
    sha256 cellar: :any_skip_relocation, ventura:        "08ecf90c31cf801b66989c931129e0836b355107fb42b0342c98dde9e7cf96ba"
    sha256 cellar: :any_skip_relocation, monterey:       "3658eeabfe9f6fa5a82e31c2cc9d873764be2ea36f52a0f0d2ba6f955aeba193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f168ef1a843ed23d5fbef2badf37f1407f417f3893dcd31b01a6133e58ff9a"
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
