class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.13/zabbix-3.4.13.tar.gz"
  sha256 "115b70acc78954aac4da0a91012645a216ee4296a7b538b60c2198cc04b905bd"
  revision 1

  bottle do
    sha256 "54c269bc1fcf897d9e31666d29ca67dc8deef7a8d0c9215eba14b157e1f44f2e" => :mojave
    sha256 "b27f4d5e4d86e4d39c295e04ec27ba3c128c7315a1f30ba54ff444f23e61654b" => :high_sierra
    sha256 "6e5e5950eb72dae5ed3755ec216e088884f9b6bb843300ceeeabff629386f955" => :sierra
    sha256 "93c611153ab56ca7f9bb0b18bbd92eee94e08a26c1f555c2cedb6c94271cdf4f" => :el_capitan
  end

  depends_on "openssl"
  depends_on "pcre"

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-iconv=#{sdk}/usr
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
