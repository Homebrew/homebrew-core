class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "http://humdi.net/vnstat/"
  url "http://humdi.net/vnstat/vnstat-1.17.tar.gz"
  sha256 "18e4c53576ca9e1ef2f0e063a6d83b0c44e3b1cf008560d658745df5c9aa7971"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 "c51d2daf263c86f6bdb40c956ca1d66f67e2babe8068a6252a866561462a63e8" => :high_sierra
    sha256 "9b2212cdc237d29d06c910ee437119f94097024e60e6a6aaf958293ffb6425ad" => :sierra
    sha256 "35c444da5787d627847714dc9ef119f9a8501ead341782c2deb18c74432d59c4" => :el_capitan
    sha256 "826ea7fb876a6d71aecdcea85bdaf5fcea55e63e97457bc6afb755518c9c1843" => :yosemite
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
