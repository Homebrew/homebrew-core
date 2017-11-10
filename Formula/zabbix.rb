class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.4/zabbix-3.4.4.tar.gz"
  sha256 "2ee84e72a0d441f322ec0ab6f332ff174dec300b3acb8389769aadeb39a353a4"

  bottle do
    sha256 "fc5f42b9ea28dc90f60b84951982951d56fafc176ac6e2d85228088e76d0c4d4" => :high_sierra
    sha256 "ec6dd70c4e463a89fbcdc8bb5cf80665e4e8dca9996124db097e296f7d34663f" => :sierra
    sha256 "37f589c679565dd1b4df33503c472e9f4d102ab42804dbc471620aec711d316d" => :el_capitan
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
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-iconv=#{MacOS.sdk_path}/usr
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
