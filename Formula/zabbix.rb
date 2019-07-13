class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.4/zabbix-4.2.4.tar.gz"
  sha256 "f6de0e0b91908d8da72d087931fb232988b391d3724d7c951833488fd96942bd"

  bottle do
    sha256 "745fe522c820335fc915529feb5df7976b687b9903ca329ec87d6ae402e8966f" => :mojave
    sha256 "37cf1ab95523b4ada2b2f91bd1a1f37c0a4c56d04ad9dc08cfdc3b1ad095548d" => :high_sierra
    sha256 "686f9150a710dcdfb7bbb47b5e67ee798b5e1a225d988ac20686b4a6e0da6e1b" => :sierra
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
