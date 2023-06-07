class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.15.3.tar.gz"
  sha256 "13b877b0961402310f45b814b1f4cefec141d0a2ff8be37d57f1ee966c41c497"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1afdd455dc7b4429eb2c0606df87319237c19f33af0b13afb34b1291b4a14f4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0f29af1add8abc85c61650166ce878cdf1ecda59acdc8f1241eed81ff99cab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58185f95c8024f7ea084866752b9ad5ace0b93cfc2c3c8945072eedb63f16c00"
    sha256 cellar: :any_skip_relocation, ventura:        "7e823909fe788f8fba715448c5d3328f232777deffd84b4b9f62c1d628254b75"
    sha256 cellar: :any_skip_relocation, monterey:       "33d64e99676261c40b07e1a01f566094acca7937cb74050f892508c72a7b4e65"
    sha256 cellar: :any_skip_relocation, big_sur:        "470ce5c3cde3b2cfca5348918d0da76cc14fe85024eecfee2ca422330264efa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4499a3ac9fb35cc997069feb9d09f23fe48c1851dfc1408783b319d44f57aa20"
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
