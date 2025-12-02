class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://shadowsocks.org/"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "edeef2408ae54108fa176b4e59cb04b4ef4dbe62da96d2459d9821b238ad94e8"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee428e1d6ec993e276efe22aec56553241c4bc9a7ab6071a7e0d4a7ba71e420b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a3a6ca29c4afa2f45aedb6f8a8f9983a925aaf103838c15af1dc770c2d3c0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9a9ed4b756fabd04e3f9fe269d6fe7ee9ce6f6ae4a3a42bc1d2b158a4d7186"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4db66def22361a5f568000c15674dbc1bd00304a3e9b27ce67db33411f9f8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "184744a4da16f787ad1a3335474b3ed2b517172739caad30dee17ae049ac287c"
    sha256 cellar: :any_skip_relocation, ventura:       "4942ab0d7e494eb5b455fdaea942c5d06f8e8280c5e3664723b37b6870dc5240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a367e4bbecf5fd29c4af66d5162dad2e4887623f57a70dac256b7f890b7174b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565f715f503e3ff45ead18a44bf9a8ce518e90d18452d6f893da2cd761c60be7"
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
