class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.0.5/shadowsocks-libev-3.0.5.tar.gz"
  sha256 "961ddbe06c2fd6299d0f181a371af16463d59e146228c53769f24e08a1d95f2e"

  bottle do
    cellar :any
    sha256 "a3fc8b78db970a9295377d350ac26bd0606eacab7447122fea26f901e96a1932" => :sierra
    sha256 "32fd757fa96b62c4970d06d3297f08e783e4248920527292a27d3f00b67c57be" => :el_capitan
    sha256 "3bc43cb6ca358ab335a480025b8c39888791b6c4d362fef4cc5e57c7b8904f36" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "libev"
  depends_on "libsodium"
  depends_on "mbedtls"
  depends_on "pcre"
  depends_on "udns"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--prefix=#{prefix}"
    system "make"

    (buildpath/"shadowsocks-libev.json").write <<-EOS.undent
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

    inreplace Dir["man/*"], "/etc/shadowsocks-libev/config.json", "#{etc}/shadowsocks-libev.json"

    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/shadowsocks-libev/bin/ss-local -c #{HOMEBREW_PREFIX}/etc/shadowsocks-libev.json"

  def plist; <<-EOS.undent
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
    (testpath/"shadowsocks-libev.json").write <<-EOS.undent
      {
          "server":"127.0.0.1",
          "server_port":9998,
          "local":"127.0.0.1",
          "local_port":9999,
          "password":"test",
          "timeout":600,
          "method":null
      }
    EOS
    server = fork { exec bin/"ss-server", "-c", testpath/"shadowsocks-libev.json" }
    client = fork { exec bin/"ss-local", "-c", testpath/"shadowsocks-libev.json" }
    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:9999", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
