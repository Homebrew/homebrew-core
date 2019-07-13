class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.4/zabbix-4.2.4.tar.gz"
  sha256 "f6de0e0b91908d8da72d087931fb232988b391d3724d7c951833488fd96942bd"

  bottle do
    sha256 "37647921daeb059678e359fb0dc1e2b6a780f46955b55c77f2901794464a26c1" => :mojave
    sha256 "409e769b96005a9fe1031089fb44abe1633f12ddb01f40de92ccf1432ae757e2" => :high_sierra
    sha256 "0d426c65ea9d4c1e383bfd2beec54fcc109af5707ec37668d664ce6d0fe90437" => :sierra
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
