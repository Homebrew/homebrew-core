class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz"
  sha256 "cfc8eded35360f4b67e18dc447b0c00cddb29cc57a3cec48b135e5fb87433488"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b6199950e5372876827efab88fb67c9c13f8dd7d9e76fef2645bbe86e7153bb6"
    sha256 cellar: :any,                 arm64_big_sur:  "b1e8d388ea9ad7619ac942468e64697c4ee10f1d969b0ad6d779a7be95c84e08"
    sha256 cellar: :any,                 monterey:       "139a812882a57f35a1338e875015b5ce57fead64d3cf3174f71c495dcf365183"
    sha256 cellar: :any,                 big_sur:        "66f3fc332d7acd21599736d33995fe421d95cc89b6d7ce9057bc72a3713ec8d0"
    sha256 cellar: :any,                 catalina:       "bbb14b97724efb4acf511b122f414a8f3f02810c7ec207413bb413063ef693ee"
    sha256 cellar: :any,                 mojave:         "292cca782f44f284592f3538dd24dd5ebdb0d1e9a978f9f507cc78be3a8e471a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd589c0338a9991d42dd08f5b470e74f3aab6843c09036d13f6b074c73a81ed"
  end

  head do
    url "https://github.com/shadowsocks/shadowsocks-libev.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "c-ares"
  depends_on "libev"
  depends_on "libsodium"
  depends_on "mbedtls@2"
  depends_on "pcre"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make"

    (buildpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"localhost",
          "server_port":8388,
          "local_port":1080,
          "password":"barfoo!",
          "timeout":600,
          "method":null
      }
    EOS
    etc.install "shadowsocks-libev.json"

    system "make", "install"
  end

  service do
    run [opt_bin/"ss-local", "-c", etc/"shadowsocks-libev.json"]
    keep_alive true
  end

  test do
    server_port = free_port
    local_port = free_port

    (testpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "local":"127.0.0.1",
          "local_port":#{local_port},
          "password":"test",
          "timeout":600,
          "method":null
      }
    EOS
    server = fork { exec bin/"ss-server", "-c", testpath/"shadowsocks-libev.json" }
    client = fork { exec bin/"ss-local", "-c", testpath/"shadowsocks-libev.json" }
    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{local_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
