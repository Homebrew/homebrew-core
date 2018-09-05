class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-1.18.tar.gz"
  sha256 "d7193592b9e7445fa5cbe8af7d3b39982f165ee8fc58041ff41f509b37c687d5"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 "71d5cfa630f710ba51faad03f8dfba4952af4143fc65b9dbe3c614d2a2ca3700" => :mojave
    sha256 "0e0b04bd9787c9f010d26e5ae3541dea2f175ba4978e6e47facfb64d1fa2b1b5" => :high_sierra
    sha256 "1dc2fe8f702bdf75b4abd1ac24602f95526dccbec90018bd1e276f1070bf66f1" => :sierra
    sha256 "19db09a61e7be5967f4574b22407628fc15d823f8d2f821bcd3cd99b7b564da1" => :el_capitan
  end

  depends_on "gd"

  def install
    inreplace %w[src/cfg.c src/common.h man/vnstat.1 man/vnstatd.1 man/vnstati.1
                 man/vnstat.conf.5].each do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf", false
      s.gsub! "/var/", "#{var}/", false
      s.gsub! "var/lib", "var/db", false
      s.gsub! "\"eth0\"", "\"en0\"", false
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    (var/"db/vnstat").mkpath
    (var/"log/vnstat").mkpath
    (var/"run/vnstat").mkpath
  end

  def caveats; <<~EOS
    To monitor interfaces other than "en0" edit #{etc}/vnstat.conf
  EOS
  end

  plist_options :startup => true, :manual => "#{HOMEBREW_PREFIX}/opt/vnstat/bin/vnstatd --nodaemon --config #{HOMEBREW_PREFIX}/etc/vnstat.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/vnstatd</string>
          <string>--nodaemon</string>
          <string>--config</string>
          <string>#{etc}/vnstat.conf</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>ProcessType</key>
        <string>Background</string>
      </dict>
    </plist>
  EOS
  end

  test do
    cp etc/"vnstat.conf", testpath
    inreplace "vnstat.conf", "/usr/local/var", testpath/"var"
    (testpath/"var/db/vnstat").mkpath

    begin
      stat = IO.popen("#{bin}/vnstatd --nodaemon --config vnstat.conf")
      sleep 1
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring:", stat.read
  end
end
