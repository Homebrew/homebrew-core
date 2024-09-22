class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "4891475a2389676e4fd3250bb579ffa7d1ad0bc9e3987c3e293c8f3a8a37bded"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38fad2eeaf92fb9668b7f9bc10f03a321c5ece15ae1ab1c1fd047eb9137fb5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f977182a198c8987b3511dcf1791b9fdf4b6427d392227be788cc0e63e2d5fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c1a2e9b10671603ad94c6bb3cf4eb0c81c8e8c4571bc80ab553efbcaa2ad5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b565375890acf7313d1f4c20f585705972076ff2f00abab5fa244825ef05089"
    sha256 cellar: :any_skip_relocation, ventura:       "12303c5352397bc6506f1e87880f89ae4462943d5276079df9ac075eb75984e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932c1a396f6299a1a77752b07bd1db147d1082c3a5dc9fbc65bafbcd1fed3056"
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
