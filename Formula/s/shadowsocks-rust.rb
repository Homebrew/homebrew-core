class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.4.tar.gz"
  sha256 "8a91836256989e3a56409d0e83da6549ecf727e2d6642cd4e707993d9c8a23d3"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a77f9c0bb65cf58a9a2defd0289914a42854cd9a974980dec468ce7e969fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6296984cb50d7fd3aef88a8809a9911db92436d4bc98caf976d8fbeaf1479b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9ce67ab52ae96cd5ccf89f8bbb64e1263633164e567fe96e4195a8f444b2133"
    sha256 cellar: :any_skip_relocation, sonoma:        "1191af72e64a9cd095770119b49bd53d345df0d5d41d9123a7ac2f371c534289"
    sha256 cellar: :any_skip_relocation, ventura:       "3a0f44423481492b31ede2596fe1eed81fe05a278fbccda0de86d5796f26006b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ddebf7cee1ecae6152b9f601e58fdd4d25386b33cb9ad196e25408993109a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48241830a76c4e367fc36ddf225cf083c84d61baa32a2ecb4bf42cb542abaa94"
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
