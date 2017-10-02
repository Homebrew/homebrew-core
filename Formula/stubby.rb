class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://getdnsapi.net/blog/dns-privacy-daemon-stubby/"
  url "https://github.com/getdnsapi/stubby/archive/v0.1.3.tar.gz"
  sha256 "5f20659945696647f7c3f4a090ffc8bf1d96e69a751bbf36e3cddb584846602e"
  head "https://github.com/getdnsapi/stubby.git", :branch => "develop"

  bottle do
    sha256 "e7dd8c7d5fac81a2f0a372ab4174c3a1942d6907f4b6cafd5f158b9641979d2a" => :high_sierra
    sha256 "a263e896750cec54cbb829f2e7f8ab26f2b85a2bae989fc6576e0be6818399f0" => :sierra
    sha256 "c4f115a00e557ad08632d585fdb2b7b8f32c8b20f68622dabe16174e83f73e23" => :el_capitan
    sha256 "6bdf61c02159995647e5c1c68a46a71f3fa792ad6b438490f4f7c8361f3c3b2f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  plist_options :startup => true, :manual => "sudo stubby -C #{HOMEBREW_PREFIX}/etc/stubby/stubby.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/stubby</string>
          <string>-C</string>
          <string>#{etc}/stubby/stubby.conf</string>
          <string>-l</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/stubby/stubby.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/stubby/stubby.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"stubby_test.conf").write <<-EOS.undent
      { resolution_type: GETDNS_RESOLUTION_STUB
      , dns_transport_list: [ GETDNS_TRANSPORT_TLS, GETDNS_TRANSPORT_UDP, GETDNS_TRANSPORT_TCP ]
      , listen_addresses: [ 127.0.0.1@5553]
      , idle_timeout: 0
      , upstream_recursive_servers:
        [ { address_data: 145.100.185.15},
          { address_data: 145.100.185.16},
          { address_data: 185.49.141.37}
        ]
      }
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.conf")
    assert_match "bindata for 145.100.185.15", output
    pid = fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.conf"
    end
    begin
      sleep 2
      output = shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
      assert_match "status: NOERROR", output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
