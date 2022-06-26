class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.14.3.tar.gz"
  sha256 "a41437cdae1279914f11c07a584ab8b2b21e9b08bd732ef11fb447c765202215"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d62b52c7b054b7c3f8e62a394b3c79b1918b445523677003a7510f32c93a1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb5ae09531a8143b8c2bf73611c093dccf9314389024d3771aaa0e78f6beb08a"
    sha256 cellar: :any_skip_relocation, monterey:       "042cae8f2613b729d11c48991ab4abf97d88995af2c0a63157ec474e48219b36"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c14fa5da61271a48cfc8618eba8adaf631ae469ba1594e0d5dbca182a97fc34"
    sha256 cellar: :any_skip_relocation, catalina:       "8eeb477f69deb528976bc2234ead8dbf7cc8428fb38fc802a558ceabab27f209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70fb502b9f580ff862b61447cca3be865dc3345b9b204581590eae7a6210ec83"
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
