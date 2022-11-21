class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz"
  sha256 "cfc8eded35360f4b67e18dc447b0c00cddb29cc57a3cec48b135e5fb87433488"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6490e3800ef7d2705e550b066a1b4c70b06e6563c9c1e5d1b8e4f2c3824611b3"
    sha256 cellar: :any,                 arm64_monterey: "bcdae7a01e62e6af170c92174da04167b501787e7b041afa652f8f267c21a080"
    sha256 cellar: :any,                 arm64_big_sur:  "0974cdce9f0a548d04d0798d9b878013075206938ebf8b68273aa57f02df3ef4"
    sha256 cellar: :any,                 ventura:        "616bbd5f8db762784be79dc2735192ab22f21dbf3219efc8e3ae2a222bc496ce"
    sha256 cellar: :any,                 monterey:       "27acec0ff096021b2a7fb186451522a74699bbd0c185e66bb460425a768bdb40"
    sha256 cellar: :any,                 big_sur:        "88117a8122f9724516e77265546624b6581b6ff3b9980bb6caf3a49fa5fd1aec"
    sha256 cellar: :any,                 catalina:       "99b4f3a61adefcca75290f2957f22bc1506779119789e0a81fe4c635fe5045e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d275effb2feb43f639da0ee1f5dfb91dce384b1815232f852386cd61f3ae010"
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
