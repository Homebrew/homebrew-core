class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.16.2.tar.gz"
  sha256 "04fb797d8d04b8af9c4746ab9c1d659a3575a677892c2d5d9194a4b0e210e2ab"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c643df2db4775837fe8f31aa01de6018641e7e8cd140bdacd2ffab5130bcab58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4351e4d1fc39ff23c9e33116dfa1818ad94388b274c0f3ef33b639835c1c1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ea2425684533a3814528b89d8ce4fc56f61486e0ff23f47ea7e3442003ef6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f845445cfc9de8dd089e8be3645629e220ef27f0031b6051a255204e112d7d28"
    sha256 cellar: :any_skip_relocation, sonoma:         "db1ebecdbd7ed0b1c8e98b44514f8d5444f46efa3f231ba5471126e1bab99e6a"
    sha256 cellar: :any_skip_relocation, ventura:        "dc17e447660be496505df393ff2727ca95e8babb67be125200339f675698e9e2"
    sha256 cellar: :any_skip_relocation, monterey:       "496935840e633fb87ee6de214f3bfe47a58f30937b9238fde22458f1e5211120"
    sha256 cellar: :any_skip_relocation, big_sur:        "54e5739ca7976ab7f90628691fd0931d690671add02e0f03b14debf85ad00d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab12362890072be18558bbcb4f9278cf8e9866d8e9c02b8cf26870bfbdaac579"
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
