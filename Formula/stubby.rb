class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://getdnsapi.net/blog/dns-privacy-daemon-stubby/"
  url "https://github.com/getdnsapi/stubby/archive/v0.1.3.tar.gz"
  sha256 "5f20659945696647f7c3f4a090ffc8bf1d96e69a751bbf36e3cddb584846602e"

  revision 1

  head "https://github.com/getdnsapi/stubby.git", :branch => "develop"

  bottle do
    sha256 "fa20a36e8ef635ffab91554d36570b54dc23123a0b8846a70a3135919465b8e2" => :high_sierra
    sha256 "c8619ef842a1f3ec495c728c5c6b02cda14adb0d91c9a496075fb9a7e07cf297" => :sierra
    sha256 "2201cc9b7e1d943e3f8aa3ad5a57c43df2513eaf647b604ad60246c4d7e5fc5d" => :el_capitan
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

  plist_options :startup => true, :manual => "sudo stubby -C #{HOMEBREW_PREFIX}/etc/stubby/stubby.yml"

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
          <string>#{etc}/stubby/stubby.yml</string>
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
    output = shell_output("ls #{etc}/stubby/")
    assert_match "stubby.yml", output
    (testpath/"stubby_test.yml").write <<-EOS.undent
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
        - GETDNS_TRANSPORT_UDP
        - GETDNS_TRANSPORT_TCP
      listen_addresses:
        - 127.0.0.1@5553
      idle_timeout: 0
      upstream_recursive_servers:
        - address_data: 145.100.185.15
        - address_data: 145.100.185.16
        - address_data: 185.49.141.37
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 145.100.185.15", output
    pid = fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
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
