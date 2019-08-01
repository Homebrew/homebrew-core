class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.5/zabbix-4.2.5.tar.gz"
  sha256 "4dba94cc8c5f1d97b596e636ff9346c3bdea59ac04a97f1236a6d5e69d72ab8c"

  bottle do
    sha256 "45016995bf5cc7b467b3cf4e6fc823c14147ea519603cceed2db5a5d3f0bad78" => :mojave
    sha256 "fe552ae2a51647d12ff59fa2ab6b1d55e5ec40d35df0e9f20da8f06ec97cf94a" => :high_sierra
    sha256 "f2348569154a5b7872e1a6a747380ffaefd2135e0a843929af9472abc0a69381" => :sierra
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

    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
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
