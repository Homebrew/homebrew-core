class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "13307594159cfe23f91e69c8b08ba7a41a17a2f36a4bfb3821476026f7518cac"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce8f75a0bb9047986b21fab8f37d9e351bac9c0749169c560091e28205e2f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50c7fed3820941a7037d962acaf5259436c68cec68ee08a0fd7a25122951e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da5871c5927e00ae0fea8bd4d3d38dba89afac1e75a0c599e1be3560bc42d3ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba5688e7decce29ee801cfb57b867620ac42cbb90d44c8a811316818add759fe"
    sha256 cellar: :any_skip_relocation, ventura:       "266827450700226be43271113bddecedbea8b2d450f90d7100c522efa68c9781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceaebe2b3c48ef7c9d6cb566f9842f5f84c264c3b7b5aea888d9d98872ceabda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81673b40baeb7f9add3e5103d26d14dbb80914a2b1718f600b0455d8ce55dc8"
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
