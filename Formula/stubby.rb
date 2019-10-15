class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/v0.2.6.tar.gz"
  sha256 "634b0b9fb8f36416e210fa65800a6c1672bcf9f4f276a042ccf89567ad8ef781"
  head "https://github.com/getdnsapi/stubby.git", :branch => "develop"

  bottle do
    sha256 "2def06f55cd7c225180d7c07686ff6047047b4696db24240fbf8c37a88cca8e2" => :catalina
    sha256 "aa05e8445978d4d7391addd20666f7ab141e9587e4585d7873052acb68aed123" => :mojave
    sha256 "e336da47ce50d92a0c3f445db4200dad8f99ba406ef454abfffb4085601e9e71" => :high_sierra
    sha256 "685cec7e37bf310b77da3680fa81d1bfc920928289c4905eb5c6899e40f6f801" => :sierra
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

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
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
    assert_predicate etc/"stubby/stubby.yml", :exist?
    (testpath/"stubby_test.yml").write <<~EOS
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
