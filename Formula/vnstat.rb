class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "http://humdi.net/vnstat/"
  url "http://humdi.net/vnstat/vnstat-1.17.tar.gz"
  sha256 "18e4c53576ca9e1ef2f0e063a6d83b0c44e3b1cf008560d658745df5c9aa7971"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 "d5a5aca6bb2c1f9a2359211de318c17e5cf7a9cff44339342c738d168c94a79e" => :sierra
    sha256 "6916d45c091113ed78ecd0fbaebf6fbd7ea7a29faf9b3365a3596eb48f50334f" => :el_capitan
    sha256 "cdd257e2409dafa0915edb66d1dbbbea40c52ce628ac6642e02bbdd742db6795" => :yosemite
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

  def caveats; <<-EOS.undent
    To monitor interfaces other than "en0" edit #{etc}/vnstat.conf
    EOS
  end

  plist_options :startup => true, :manual => "#{HOMEBREW_PREFIX}/opt/vnstat/bin/vnstatd --nodaemon --config #{HOMEBREW_PREFIX}/etc/vnstat.conf"

  def plist; <<-EOS.undent
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
