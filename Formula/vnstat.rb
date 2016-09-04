class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "http://humdi.net/vnstat/"
  url "http://humdi.net/vnstat/vnstat-1.15.tar.gz"
  sha256 "c3814b5baa8b627198a8debfe1dce4b4346a342523818cc8668a5497971dbc39"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    cellar :any
    revision 1
    sha256 "649f48180888b9dc1cb3fd60fac3d1dcdf56ff5a0f2b57a831c08fcad201b0ab" => :el_capitan
    sha256 "ef27ae97c7a698631fef3f78cbe334d7347d40e06e697f012ab9fa925b7daf93" => :yosemite
    sha256 "80d5c778de2d86d77761abf2a2eaa53707989287ce157085f11cad350d7ef0e1" => :mavericks
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
