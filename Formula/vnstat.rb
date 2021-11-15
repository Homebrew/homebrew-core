class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.8.tar.gz"
  sha256 "03f858a7abf6bd85bb8cd595f3541fc3bd31f8f400ec092ef3034825ccb77c25"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git"

  bottle do
    sha256 arm64_monterey: "17d72eee03c37131ab65a80500885f44f5b96cdd242eb25dcb887a08eac29bfe"
    sha256 arm64_big_sur:  "1b3dd9ca73892c5a80eaf5be1e7e71a8ec7035a8539ebefff3108c169b264871"
    sha256 monterey:       "cf5082ac9dec5d1b11f4c67e197e60053969fb185590690eba7f83280fa46bed"
    sha256 big_sur:        "fd1ec9717260fdab127a4bedc0b37fa8e7ddf7cbf98f580d4a09ee83c8732fa8"
    sha256 catalina:       "f77d3b9d0d6255cb9e25bf8d55f4b77e65bb4d042e4967994694f86f02efc403"
    sha256 mojave:         "6dcdff6ebc18f04db1c1774a170111147a30a2b9b1fa9c3aede34ef0af7ed683"
    sha256 x86_64_linux:   "6741cfc8070a737a45db2a57c4a9fc3b9a6e505e4a1cbf97be5b37bbeb33a58e"
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
