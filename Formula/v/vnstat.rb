class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "https://humdi.net/vnstat/"
  url "https://humdi.net/vnstat/vnstat-2.12.tar.gz"
  sha256 "b7386b12fc1fc6f47fab31f208b12eda61862e63e229e84e95a6fa80406d2852"
  license "GPL-2.0-only"
  head "https://github.com/vergoh/vnstat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "70a572931b614b41fb3e5957961a0b42f4f6da7c5804c4cfba78e8008f10ed02"
    sha256 arm64_sonoma:   "b9f2f91ebb02d0abeac163c0964816202483cde13f53832cbb390e477fa344df"
    sha256 arm64_ventura:  "ba02bb2d0ae58290104e3ee06cdc915d16007f53c45833081083f52bddb4cf6f"
    sha256 arm64_monterey: "638b93276b154fc5339c440e98961d986fae27d855a1ad22e764cffa53818735"
    sha256 sonoma:         "f9e45487f466e1d613f2880d278b47f324e6142b0e73b711add74e9d0f672e07"
    sha256 ventura:        "2ab99304bb533b71dc0df069bbe8795bd053723d724600e538b5aedb0fb7b625"
    sha256 monterey:       "46d35cbc5297d77dea91df6a1109fb6313e715a201af6051d327853586feb6a9"
    sha256 x86_64_linux:   "242acd29230207c57e434823a2246674d0e1efbf7f4f61db859437affacb5857"
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
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring", stat.read
  end
end
