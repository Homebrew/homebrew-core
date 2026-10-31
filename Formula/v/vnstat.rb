class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.14.tar.gz"
  sha256 "8ba2119b3c6f780775135f9c9fa7236867da67e2f93649f1313319b9cf48f87c"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "b7eb5adecfcdc822695d4b2c52af8ec88e666f0e77f52debb0880071e5a3c251"
    sha256 arm64_tahoe:       "e469576c2e21e2a6e9582f64af470b7d3f64de22f5d2163c04b5cafe5c66d948"
    sha256 arm64_sequoia:     "adda142efebaef3cad3a8c4d9c9e3e632ae25244dd08f02e8762a4d72e71fb10"
    sha256 arm64_linux:       "c97f5164b3113976f6e79c483f2f16a65216b15bdd6330427dabeed1ca88073d"
    sha256 x86_64_linux:      "df00ad15d5c9e769a871b276785a574a51042d472396900b39d6cd4c0c7d2167"
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
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring", stat.read
  end
end
