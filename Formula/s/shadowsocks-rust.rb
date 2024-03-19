class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "b772792e2d3f8ccc3a5d5255bfc65b85801b97e1139bbb0e50d39a91fb7d9e61"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4a636fb500a6a9c060eb38d62a0865ff218629b4ceda3efbf56aa07c72d127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9c5cd2423a657894ee1c03cd6d27c6cd76b0cdf6f68a6238788f8a6942ab72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0638dc9f4885beb31d612bba637e7321e9800aa68816a642d1143beb010f1b73"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89bd98378c7882a03da946a8144e4b64f9354662c9cc178f746aea3fe107f67"
    sha256 cellar: :any_skip_relocation, ventura:        "9ae3ed404fc9bc0daaba162f7a6be4d9f0a577cb7984b11d3c875fee49743ded"
    sha256 cellar: :any_skip_relocation, monterey:       "98eabba2433e05a0fd53c5c66fc472d0cffcc35078469ecb0010dbcfa019ec10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b274921576d514cbbe07a110fdcb4761f003a409ea20133aa91c85333bead0b"
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
