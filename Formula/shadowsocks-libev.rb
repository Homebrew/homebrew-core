class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz"
  sha256 "cfc8eded35360f4b67e18dc447b0c00cddb29cc57a3cec48b135e5fb87433488"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any
    sha256 "528247af041993c5b670c882df5c687de8107155c11040d9264f3a32eaf8b60a" => :big_sur
    sha256 "1c324cc200e2c895d672f36f239e2c48588ced81ea9716643a0b2b36757fb7e9" => :catalina
    sha256 "83a23ecda43df6ef6097aa728de12f4dab8f1595cc9197ef8e29b4b1e5fd8822" => :mojave
    sha256 "d6f9af357976033c8965e8b8bc7d52a8023b1ec797378f9dd292e74a43c0b134" => :high_sierra
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
  depends_on :macos # Due to Python 2
  depends_on "mbedtls"
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

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/shadowsocks-libev/bin/ss-local -c #{HOMEBREW_PREFIX}/etc/shadowsocks-libev.json"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/ss-local</string>
            <string>-c</string>
            <string>#{etc}/shadowsocks-libev.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
        </dict>
      </plist>
    EOS
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
