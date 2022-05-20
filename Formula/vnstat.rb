class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.9.tar.gz"
  sha256 "11a21475dea91706500aba7c63e24126703fd01f13b1f3acdf92baa5aead9dc7"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a9d126ced5b400cfd9fdd67762f0abb7b68d484168eb1d376de589e26401cafb"
    sha256 arm64_big_sur:  "9c449b01cc80fcdffad166dd457f08cd5060a4ebbd40d4f947c4abb401b6084a"
    sha256 monterey:       "bba4e7167e3d1ae02c828a3a5cc561b98f3915aa2b4d058300d62414f7d446cc"
    sha256 big_sur:        "095e49284800aa41b7cd7808b902a1b451c302c1a4bea0b4a41d93c3de0ede2f"
    sha256 catalina:       "f6f4328d86add848e05f6a14a59844bb8a32fabc1f9b77cccd86958eba2ffc83"
    sha256 x86_64_linux:   "8d8dd227883a9cdfcf31b7a8bd6478bef463fc2efb03d162ca643e293c8ac03a"
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
