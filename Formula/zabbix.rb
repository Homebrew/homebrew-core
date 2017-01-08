class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.3/zabbix-3.2.3.tar.gz"
  sha256 "e6dba74039d8d6efff86ec3da99909f4daeaeb66d48781bbb666e3094533da25"

  bottle do
    sha256 "523d9352eea76c38dc11ab1c991405936e1c289c534f7ce03147b5e7f248fed1" => :sierra
    sha256 "e9baa9e0cd489484d4a403a8e45e5148d45a4e9474ec50481e7bde3e71928ea4" => :el_capitan
    sha256 "798afed3776b500f352d0d7fbf6a170441ad8096df304edea51748b0a2679a17" => :yosemite
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
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
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
