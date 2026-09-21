class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "477a525e9b11d4c90ded6629552548d00a32675ec6f6f18ee45c98447e54b5f3"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37e008de94c17afd94f7810bc30169f4895ad626de6a4e40072e1d36a6c98bd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bdad773ad3a247ed1677a5e00d56b7fda4d0dde1eec11fd941857e5ccec6197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9829b51b4becaaf58079e168b9463447bb76f3ba4cd5f94584307e0480fbe6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8f1ea98d7c9f566fe1920f3cabe73201c19a6a01aa217de0c55d2fcf8fe7eead"
    sha256 cellar: :any_skip_relocation, sonoma:            "067ffe898a4a9f666546749401260190382c90ff74ba3d7eb1f7ff781180db3c"
    sha256 cellar: :any,                 arm64_linux:       "6bd4303ff121f5ec0011c9277d9aa19969115fa564f523dfd3aa10bee84ea23d"
    sha256 cellar: :any,                 x86_64_linux:      "c7a40d35bb6edd573ae3687e3816ba68ee52cc3d2bda8cf2ceffdcb657dfb804"
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
    spawn bin/"ssserver", "-c", testpath/"server.json"
    spawn bin/"sslocal", "-c", testpath/"local.json"
    sleep 3

    output = shell_output "curl --socks5 127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
  end
end
