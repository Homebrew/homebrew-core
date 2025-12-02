class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz"
  sha256 "cfc8eded35360f4b67e18dc447b0c00cddb29cc57a3cec48b135e5fb87433488"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "613c265dfbdb7f3686e9b5d533aa4993ec78fd5772c44a8872ed76094b5a8a03"
    sha256 cellar: :any,                 arm64_sequoia:  "1634eda3b34216de2f4208756ef79a7a3cf9dd92aed1efe90657f069ad25f95c"
    sha256 cellar: :any,                 arm64_sonoma:   "36afad86fca33908c9f81c18511aa4d59f6114e4dc85b66735eb1450bfec79bf"
    sha256 cellar: :any,                 arm64_ventura:  "c56ecc0ed12edf94c2f375ce6cbb0b878501dbf7696cd223211a095f84b362d7"
    sha256 cellar: :any,                 arm64_monterey: "5baa9ccd2a55ca92f1951b7c25839b6dd4b0fc9a1cf9a3f7238a1f7f7b6ed5b5"
    sha256 cellar: :any,                 sonoma:         "089044be226fa8913cea75aa91e488c9b0a4a20bdab101c53bcf73629b912a39"
    sha256 cellar: :any,                 ventura:        "64e0226723e4b01a528bd151671bf72cd53cb620821f7db372a1776eea430cf3"
    sha256 cellar: :any,                 monterey:       "3f8d3f710752c395800db2d8805d126c67a4ea63665ce24eb8f4d562d3f139ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b81d13f1ecbfacb40446d83b12acf298aaeaa326d06c15aaab11606848c87d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707c0ff929995f51fd54807d4a569a754173288596df027fd49290021a25a1a0"
  end

  head do
    url "https://github.com/shadowsocks/shadowsocks-libev.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # From GitHub page:
  # Bug-fix-only libev port of shadowsocks. Future development moved to shadowsocks-rust
  #
  # Unmerged dependency update PRs:
  # * MbedTLS 3: https://github.com/shadowsocks/shadowsocks-libev/pull/2999
  # * PCRE2:     https://github.com/shadowsocks/shadowsocks-libev/pull/1792
  deprecate! date: "2024-12-31", because: "uses deprecated `mbedtls@2`"
  disable! date: "2025-12-31", because: "uses deprecated `mbedtls@2`"

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

    (buildpath/"shadowsocks-libev.json").write <<~JSON
      {
          "server":"localhost",
          "server_port":8388,
          "local_port":1080,
          "password":"barfoo!",
          "timeout":600,
          "method":null
      }
    JSON
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
