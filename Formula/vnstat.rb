class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.8.tar.gz"
  sha256 "03f858a7abf6bd85bb8cd595f3541fc3bd31f8f400ec092ef3034825ccb77c25"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 arm64_big_sur: "31160d2bd7a24af3e788d29b9465399ec27bcfe5b44bdf9a9d2176b540245fe9"
    sha256 big_sur:       "817351cc1ffa85d14ea28c820837e9077d77302f0e2439a9686e22d0ebbc1093"
    sha256 catalina:      "5167bdbf374cb87411a3b3aa5b431f2777a90bff8fec599079794f06f0511dbb"
    sha256 mojave:        "7c13d764a6f0fc06d1ea7a7800c568c2cab8f02ed2f50b12d62cef720c7baad9"
    sha256 x86_64_linux:  "e4c902e80f8d1c70a08b266d7dc5440b67135fa5803a72559413a551a35e7816"
  end

  depends_on "gd"

  uses_from_macos "sqlite"

  def install
    inreplace %w[src/cfg.c src/common.h man/vnstat.1 man/vnstatd.8 man/vnstati.1
                 man/vnstat.conf.5].each do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf", false
      s.gsub! "/var/", "#{var}/", false
      s.gsub! "var/lib", "var/db", false
      # https://github.com/Homebrew/homebrew-core/pull/84695#issuecomment-913043888
      # network interface difference between macos and linux
      s.gsub! "\"eth0\"", "\"en0\"", false if OS.mac?
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

  def caveats
    <<~EOS
      To monitor interfaces other than "en0" edit #{etc}/vnstat.conf
    EOS
  end

  plist_options startup: true, manual: "#{HOMEBREW_PREFIX}/opt/vnstat/bin/vnstatd --nodaemon --config #{HOMEBREW_PREFIX}/etc/vnstat.conf"

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
    inreplace "vnstat.conf", var, testpath/"var"
    (testpath/"var/db/vnstat").mkpath

    begin
      stat = IO.popen("#{bin}/vnstatd --nodaemon --config vnstat.conf")
      sleep 1
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring", stat.read
  end
end
