class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.13.tar.gz"
  sha256 "c9fe19312d1ec3ddfbc4672aa951cf9e61ca98dc14cad3d3565f7d9803a6b187"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "af145bbd1da554febe818a33724a04fd13316d589279f3e7c7dd44178556f1ae"
    sha256 arm64_sequoia: "22d6d6ad688b31df0baaa7ba2fb89124c36656c59a3a1d3362fd71aea74a2d26"
    sha256 arm64_sonoma:  "00d035664c11d7302dc5e4cf16e09539e0f598bb3ab309036452b3dca029c0be"
    sha256 sonoma:        "edeb08c785444734a8d1c2952fb88959b058406792628f3b99e10f744f207057"
    sha256 arm64_linux:   "c390b99feadced13f30746c1f6caa889592001edb5a001cde6a40bed344728e7"
    sha256 x86_64_linux:  "41fb94bbbdbb6533741c6cd5b0cdf6e1713ce55b499ef80950cf31a94a25015e"
  end

  depends_on "gd"

  uses_from_macos "sqlite"

  def install
    inreplace %w[src/cfg.c src/common.h man/vnstat.1 man/vnstatd.8 man/vnstati.1
                 man/vnstat.conf.5].each do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf", audit_result: false
      s.gsub! "/var/", "#{var}/", audit_result: false
      s.gsub! "var/lib", "var/db", audit_result: false
      # https://github.com/Homebrew/homebrew-core/pull/84695#issuecomment-913043888
      # network interface difference between macos and linux
      s.gsub! "\"eth0\"", "\"en0\"", audit_result: false if OS.mac?
    end

    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"

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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring", stat.read
  end
end
