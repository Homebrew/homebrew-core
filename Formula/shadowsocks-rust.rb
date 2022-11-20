class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.14.3.tar.gz"
  sha256 "a41437cdae1279914f11c07a584ab8b2b21e9b08bd732ef11fb447c765202215"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef6ca7c523f0ecdf36c3c0e15b99b45db4047dfa1663b626af039336b642ff93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17936e8eb86b5ff303096dd7923809b47adace1da94229214dc60f5ed41893c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b3636c79f802d2305ab5f95a9aafd3d27b78728f6abfd2682c9bfdf29fc9d3a"
    sha256 cellar: :any_skip_relocation, monterey:       "26207795fd9e7f6b259843ff368f1a819aa4b3f39930dc2866c9a4462e4cb05b"
    sha256 cellar: :any_skip_relocation, big_sur:        "73964b24b192d5b587cb9c2fb609a8c3647781cd70d14b7df504e05e2286fade"
    sha256 cellar: :any_skip_relocation, catalina:       "bc40e0a0d04b9c173bcc625ea3c38c448d22e51d41215a9a4dd526d49f1f1eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0068e74e25ff5228d4f5767ab23cc7236dcfb465af7e18ce09fdc0efcd5fa037"
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
