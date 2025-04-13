class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.13.tar.gz"
  sha256 "c9fe19312d1ec3ddfbc4672aa951cf9e61ca98dc14cad3d3565f7d9803a6b187"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "01d7585fcf02e3595ca5c701ae5756ca1b9b4e4ee2ef4fb2e76ea07dea677160"
    sha256 arm64_sonoma:  "cefa8fe3c1f63ad65685d6e812b79176faab950dd28fa1fbc8955d56ad4f2910"
    sha256 arm64_ventura: "224ef1e8f2893b154ecd52d8999fb9f3f4ce57f4b565ac7881ac9250d5287505"
    sha256 sonoma:        "d0bb412ae03b8ddd2b071926ca8cd5b92420c9fa435546a2fa7f0570a2d7c6aa"
    sha256 ventura:       "d719d32162aa76bdfa057cb4ef089a864bafb31855d4355ba1e8e5e1cf3a9db9"
    sha256 arm64_linux:   "a2f1ff3f507091717d9c0b8b2d407a806d7435aa28e9b163203a72616b6a0c84"
    sha256 x86_64_linux:  "cb0052ce9d13c668838ca8dcd339f852ab9508fc41b1359ac712baf7322b29b0"
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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring", stat.read
  end
end
