class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.5/zabbix-3.4.5.tar.gz"
  sha256 "f764f02dc87f43c7d32f0c977b1b4a176ddc70012a072733aeee38ccacf6cdbf"

  bottle do
    sha256 "a1d6ee981db9e9a795e56c6f2a68fdf769d23ec5c69a2186e979a0048d69f7b7" => :high_sierra
    sha256 "c1a46a3f2228522d22801eef9169f743a6ac15ee240316ac88535e83db5331d0" => :sierra
    sha256 "a39a73ba47ec01133578b4ccf5829aff9ec296b1a2409e13e2ccf0321a909944" => :el_capitan
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "with-sqlite", "Use Zabbix Server with SQLite library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."

  deprecated_option "agent-only" => "without-server-proxy"

  depends_on "openssl"
  depends_on "pcre"

  if build.with? "server-proxy"
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? "mysql"
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
