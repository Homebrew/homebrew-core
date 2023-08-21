class ShadowsocksRust < Formula
  desc "Rust port of Shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"
  url "https://github.com/shadowsocks/shadowsocks-rust/archive/v1.15.4.tar.gz"
  sha256 "d3077af7d292ff2a0d36e9debb2104e37ad998deac4dd6eb0674b8fe7d41cf20"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c67b36d6fbe591bf842ef3e211cb3a5e6ce57ffbf631d884a0312f0a43e0365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae8f4672096f472c3c79c9be3a298baad6da28e5c05d1d87b9087d8a972336c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58b79ff7aab28cbab0a4f3bd7bef44a1f0f9c6b50c57000a6860221e45e7fe8b"
    sha256 cellar: :any_skip_relocation, ventura:        "b46fd72b4c4dd4126b45771d5534c4a0f89f4ccd5d8fc16664866bc25e335975"
    sha256 cellar: :any_skip_relocation, monterey:       "581031ca8cfef89c66cff38278fcbc4286b90fde49c1747f9752e210915fb56d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a97d6789cbd4d0550267478a603c0293780a415a2a26d590ad1697360c40b4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b81108b06b272e265f95bed8b06e7732b0c6b638e70741b5c7b9b99f7196fca"
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
