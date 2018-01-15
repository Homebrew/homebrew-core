class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.6/zabbix-3.4.6.tar.gz"
  sha256 "2c261f967fece8f0f930bc07876e37debdf7a903f65a3a222aed5ba5fc724d6a"

  bottle do
    sha256 "23c2dbb1780ae0f2ac1ba16a56608cb581b10c9c484810fb80e7e46c83db899d" => :high_sierra
    sha256 "e0a2256246104f2864378c01e92156ba595ce4aa6a57e3545f82ba16a938cbdf" => :sierra
    sha256 "12618619f2b2edee21c6efb3dbf2cb14f98c2ddd2da706748c456526854500aa" => :el_capitan
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
