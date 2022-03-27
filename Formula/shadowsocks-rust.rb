class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.14.2.tar.gz"
  sha256 "3a72c0f40d13d8ef185a7a68f00c8c0e022682d19fc46c11440379580cf30c04"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604ad0748ece4ac7c9d0c23f316005c73cf7c8e2da64f0dcd3365c58e0f0ea13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e42ef2d538a53959243634e3fe26a31ed9e54da12a2d310af55ff6920560742e"
    sha256 cellar: :any_skip_relocation, monterey:       "325aa94568961ffabd71a20a82b6eaa6270bbcadff260a313d9e917d78e107a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "07aeab5a26c455c857c846064ac9e7a7b067663dd7e94b814a6983a6157a5b8b"
    sha256 cellar: :any_skip_relocation, catalina:       "ef7e7827093e1c2599a78094c2e73f763aedcc9cb2c9c5ccb82e9eb5486e0233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5571d2b8ad5181288ff24dcdcc408d9eb9a1ac569d02ec4ae135f7d25545893c"
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
