class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev.git",
      tag:      "v3.3.6",
      revision: "c5e8788013a37afe54ea1c2b7c03395cccc663cf"
  license "GPL-3.0-or-later"
  head "https://github.com/shadowsocks/shadowsocks-libev.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a42fdc941a6684fc34969d13cfb8943ab85ec4759e6648969c568c08f91578f9"
    sha256 cellar: :any,                 arm64_sequoia: "bfe681be47331281dfa702c0869bc11e98881b4f3c0fcec40fbaf4cf480935cd"
    sha256 cellar: :any,                 arm64_sonoma:  "19bf52cee9260d0669dc847fe5ecf000b905c4f8be5f303df4071db906082d36"
    sha256 cellar: :any,                 sonoma:        "790bc99c821cc3fd8b4a685e37ec40ef4a6c0f470911a43b1863db3af4773f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ee4c22c4c47e0a887832c226ce0d422fd69133a648afdb718f651faeff05e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e622c9cb22667b5b5b27358b753e6d6a987df4620f56ca811ee54c6505e8a573"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "xmlto" => :build
  depends_on "c-ares"
  depends_on "libev"
  depends_on "libsodium"
  depends_on "mbedtls@3"
  depends_on "pcre2"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DWITH_STATIC=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    etc.install "debian/config.json" => "shadowsocks-libev.json"
  end

  service do
    run [opt_bin/"ss-local", "-c", etc/"shadowsocks-libev.json"]
    keep_alive true
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"shadowsocks-libev.json").write <<~JSON
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "local":"127.0.0.1",
          "local_port":#{local_port},
          "password":"test",
          "timeout":600,
          "method":null
      }
    JSON
    server = spawn bin/"ss-server", "-c", testpath/"shadowsocks-libev.json"
    client = spawn bin/"ss-local", "-c", testpath/"shadowsocks-libev.json"
    begin
      system "curl", "--retry", "5", "--retry-connrefused", "--socks5", "127.0.0.1:#{local_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.wait server
      Process.kill "TERM", client
      Process.wait client
    end
  end
end
