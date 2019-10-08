class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.4.tar.gz"
  sha256 "a0955999abd56d5463d257ffdccc9b1e9ad9ea504de81e64ba4c197f1245abaa"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 "28ca5fc572b83efdeb8f186debb37e7d21c0255b26273cc970d45d1aca6346c6" => :mojave
    sha256 "2ba06d6af371f3ee26e98357db8d58849c15ed5bc8536e71b5796927805ad92d" => :high_sierra
    sha256 "b3fba4ea86b675bdab6147eeb51b705be074203d4974d0b7f09221b1ad2b0a41" => :sierra
  end

  depends_on "gd"

  def install
    inreplace %w[src/cfg.c src/common.h man/vnstat.1 man/vnstatd.8 man/vnstati.1
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
    assert_match "Info: Monitoring", stat.read
  end
end
