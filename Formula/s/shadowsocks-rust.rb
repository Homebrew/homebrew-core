class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.16.1.tar.gz"
  sha256 "da4c6256247207b2579721046292bab1a2ac62301878c73ff778c168caa8a990"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a168207fbb7aff5e13a085543cb8680f5daab79611ac190c22baf98f4c748097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13c24c938504acb43e94e8c486424370b4fe3154a4948eebb8b2a117f06cb9f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b20bf72d72a113283e20dab53e20fbb94c9515b665d11896af0f2103821256"
    sha256 cellar: :any_skip_relocation, ventura:        "ebf44dfb702b568ef587e943ae273b4d564c726902193758cb9e6f6e1d3342b4"
    sha256 cellar: :any_skip_relocation, monterey:       "08f295c7bea58d73b6fb7e42a7a6d5784307cf6e247452e362570b36a142d60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a82cc671390a247b78c319965dd0ae46996d4821077787b20fa747c0e7b09873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700cefc112657c9362e34099df24ad9b605fcf40a4ae2a0df2685b0d3d9ce0f1"
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
