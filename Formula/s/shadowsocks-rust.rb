class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "c818124252528886dd2a26c0f4730a34cdeb5764c3812cae0d98e9fc9c1d8ce9"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27156ad4e507bde6d9c3d8772c581c2b4f9e597a26638f213b56644a6fdaf201"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1454c8807bc071ac43c597c5811adea9dd0378f4ca7a6b53f881202822bdbc17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac773004418b13fe49ca44326d30fa4be7fb0dcf3d3b05b20d21093aeba5e8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "81f9c671d3863859735b16b0e69551b6f555e0d6a1ffb138e6a284c0ebcba71c"
    sha256 cellar: :any_skip_relocation, ventura:        "312bd80381d425c1dd3357561cd9c5d518fe9acebfa23ae46b167c9e3c1e12ee"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbfa28aea8ea1ed20e617038fb06710dd9a7484603005ae09b11eb2a9fe5946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c38412cfbc6bba96602bf3e9e26ea5558a990ff80d10eb20d4f804048ce516ed"
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
