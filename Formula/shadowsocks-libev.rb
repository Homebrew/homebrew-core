class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.6.2.tar.gz"
  sha256 "1fa5b70177f7c125cd10b46d590274c22b4bded26bf3d2372ab73829dc4b7c97"
  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  bottle do
    cellar :any
    sha256 "916639de13803de4b63e213b6d25018dbfef1bdf844b078ed360bd1d5a3a929c" => :sierra
    sha256 "0d5aa5b59837b809f541a610201ab692c9ce082009306cd6006254ee0cec9f19" => :el_capitan
    sha256 "fd0600f6b4e6cd4dad76bfe1fa394963ec230bc86c357600f92fdc22bed4895d" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl"
  depends_on "pcre"

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
          "method":"table"
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
