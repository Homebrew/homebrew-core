class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "2857372667b66aa7f8ef2d27a8a19209cbf3e5da2e6d1d1d493411d72d173861"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "019c5f23cb3676ec1774b49a9134a49b597680363e42d62c47a293de4514107c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e030e4abe5e96fa0364f5609cfb134ba0d165ffe946540e8074284616d2efeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1c016821c9cd5c96c4fe6e33cb70f7200da3d938edf45afbff634cb8642f74f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b21ccba1c553071f190d689eea861846d558245f36e20ad2c8928f10eeacc840"
    sha256 cellar: :any_skip_relocation, ventura:       "c227603f53a0219a36917fcc56c29780713208b3c89c945f3481e0a2702158cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee251afad6da19d3bc60433e74adf252c864eb47b247ab27381ee5092f73953"
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

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
