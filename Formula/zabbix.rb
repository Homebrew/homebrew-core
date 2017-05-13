class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.6/zabbix-3.2.6.tar.gz"
  mirror "https://fossies.org/linux/misc/zabbix-3.2.6.tar.gz"
  sha256 "98f025b39515b196552b8a23e2fe20a8180b5e99e613ce7378725a46ed8b62d6"

  bottle do
    sha256 "53cf139fba01e23e9e99d376bd87eb731a4f4820893be1a959dcc6b3e5031e6b" => :sierra
    sha256 "8ab8b527d7d05970133f06f6e3218be819c2c7879555a3a76c3009c4b1770d8a" => :el_capitan
    sha256 "aabb18d6d862d1fc6d594f1cf5752f378ed4f8e43b3ef5c687d82d1d28de7d15" => :yosemite
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "with-sqlite", "Use Zabbix Server with SQLite library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."

  deprecated_option "agent-only" => "without-server-proxy"

  if build.with? "server-proxy"
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? "mysql"
    depends_on "fping"
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
