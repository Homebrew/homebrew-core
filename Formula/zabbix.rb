class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.13/zabbix-3.4.13.tar.gz"
  sha256 "115b70acc78954aac4da0a91012645a216ee4296a7b538b60c2198cc04b905bd"

  bottle do
    sha256 "54c269bc1fcf897d9e31666d29ca67dc8deef7a8d0c9215eba14b157e1f44f2e" => :mojave
    sha256 "b27f4d5e4d86e4d39c295e04ec27ba3c128c7315a1f30ba54ff444f23e61654b" => :high_sierra
    sha256 "6e5e5950eb72dae5ed3755ec216e088884f9b6bb843300ceeeabff629386f955" => :sierra
    sha256 "93c611153ab56ca7f9bb0b18bbd92eee94e08a26c1f555c2cedb6c94271cdf4f" => :el_capitan
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "with-sqlite", "Use Zabbix Server with SQLite library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."

  deprecated_option "agent-only" => "without-server-proxy"

  depends_on "openssl"
  depends_on "pcre"

  if build.with? "server-proxy"
    depends_on "mysql" => :optional
    depends_on "postgresql" if build.without? "mysql"
    depends_on "fping"
    depends_on "libevent"
    depends_on "libssh2"
  end

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

    if build.with? "server-proxy"
      args += %w[
        --enable-server
        --enable-proxy
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      ]

      if build.with? "mysql"
        args << "--with-mysql=#{brewed_or_shipped("mysql_config")}"
      elsif build.with? "sqlite"
        args << "--with-sqlite3"
      else
        args << "--with-postgresql=#{brewed_or_shipped("pg_config")}"
      end
    end

    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "server-proxy"
      db = build.with?("mysql") ? "mysql" : "postgresql"
      pkgshare.install "frontends/php", "database/#{db}"
    end
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
