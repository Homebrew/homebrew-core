class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "b772792e2d3f8ccc3a5d5255bfc65b85801b97e1139bbb0e50d39a91fb7d9e61"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b27f71fd1241cca9f245d959a3d384587caefe71c430824b5415487b0f48767e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1fee89b5005f42e6fe5c860f837b4ede39a7a078c56f5880c686d984f4a7027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1bcafdace76233da2f149e6e554407f94ecca05a480f2f14318913a287bd286"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ebfe58a3147a5c774438eeaa3695bda1889974f320202a9e8cf2de1de927816"
    sha256 cellar: :any_skip_relocation, ventura:        "5378908d371aacf5b2c39188fc56bf54603849a91d4b44f54cf5fb8a3ffa0beb"
    sha256 cellar: :any_skip_relocation, monterey:       "05b36bb1a67a9c57d874ebaf3caa0a2f43fb428af6b3a77ee98f0e9bf2024fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e370ebd2516787d8784640540ead53c070a3a498168d1967c37639946f75859"
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
