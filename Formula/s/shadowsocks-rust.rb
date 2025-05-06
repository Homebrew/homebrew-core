class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "1bede0eb443063c37317728d568638e3348d86f1292c9864c5bdc5a9f96d8b7a"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7943900af07c8410b201c5da30e52df54e68ca8635678a1b2b4cf26f86c6eaa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b825017b963c446f7ffe3764580e4884c7fb0e168e84187742ba54cb98dbcbee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e7c619089aa9c491de92fd7065ae4d7df9b11f6ec4a18110623991c4b01d5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9038ad8f46aea43855336db6ab87851802b9336daa7c1d3c6b131def6710f278"
    sha256 cellar: :any_skip_relocation, ventura:       "fc509dd8d940a1151eb200390086c7845eb8a4ba7bc55ff02f4923091feca073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238c2730627062843ff9e3d6b82b730b3b90f42f0909bfd04b7b28a204b0b537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5aae3e5b91f62093d2a9d92a645b72663ae98bad5891ed90b4e8e3fd1f4aff"
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
