class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.11.tar.gz"
  sha256 "babc3f1583cc40e4e8ffb2f53296d93d308cb5a5043e85054f6eaf7b4ae57856"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "273d5ae9920f32ad1fc22a8cd3a8cd16021175d380059489ceee02f189bfe72d"
    sha256 arm64_monterey: "40d35d2096727b3e8cafa2b23de4a75fe6e7d104b336cd10d54b5c3d24333425"
    sha256 arm64_big_sur:  "eda88fe18783d34e22d4b7d04efa303f588c5a112a12e93e816816f97c6279c0"
    sha256 ventura:        "8989044eaebd33345f005c005fca3a8f7a5a04f71a72bac0585c849056173fe9"
    sha256 monterey:       "1a4999f1e59b1c1d21500e7df3dad26ffbb198f589cb9f3d337875ac8c985691"
    sha256 big_sur:        "7180971117aa772820ca83052f282c855e0fb2b0ab5186b69f055fde257441d4"
    sha256 x86_64_linux:   "176ea16a1ca4a86515db372afaa28e49863fbb2fa14b68c586327142de5c36bb"
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

  service do
    run [opt_bin/"vnstatd", "--nodaemon", "--config", etc/"vnstat.conf"]
    keep_alive true
    require_root true
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
