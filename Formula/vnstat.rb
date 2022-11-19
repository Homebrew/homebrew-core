class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.10.tar.gz"
  sha256 "a9c61744e5cd8c366e2db4d282badc74021ddb614bd65b41240937997e457d25"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "bd9a2bfadf1fde522bdd1585143fa20ec241cf45122326818d03978b8b60ef03"
    sha256 arm64_monterey: "5e96e31ef8696a64e1906d4ffae3c4eac62c4bd253bcdf5b8338b4d6d01d0941"
    sha256 arm64_big_sur:  "37aa0b638d91053d9cf4db7f8018e916dda834f78dc7dadcc9035d7da051b588"
    sha256 ventura:        "ebb8ec94d4039ce7f59dfd299cd36f84b46e7e4c73371cb5f625a3c760268147"
    sha256 monterey:       "930bbc22109b08c0a26176980d02035df26b0cc9708a5fb0cdbc4a3fd5882e4c"
    sha256 big_sur:        "8436229f2365d0651efb45aecd9779c2dd55fccd4582d0b537d2c2755cecc349"
    sha256 catalina:       "0ed1bb9f2b172352da86411952bb6497e5a8de075c0f0eab3567ce4a23369080"
    sha256 x86_64_linux:   "585625ad0406edac731722bfa00226da552b038b73bd185f39dd638c7fc7081b"
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

  plist_options startup: true
  service do
    run [opt_bin/"vnstatd", "--nodaemon", "--config", etc/"vnstat.conf"]
    keep_alive true
    working_dir var
    process_type :background
  end

  test do
    cp etc/"vnstat.conf", testpath
    inreplace "vnstat.conf", var, testpath/"var"
    inreplace "vnstat.conf", ";Interface", "Interface"
    inreplace "vnstat.conf", ";DatabaseDir", "DatabaseDir"
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
