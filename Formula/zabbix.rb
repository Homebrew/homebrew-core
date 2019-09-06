class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.6/zabbix-4.2.6.tar.gz"
  sha256 "646b1f29a768e3123a00a9afadf382b4d0dfd54e20fb31023f0d6da066da0864"

  bottle do
    rebuild 1
    sha256 "b8015f092ec6b236f052bbebe88e2b0fe18aef20699fc3a3cae7daefcc47e795" => :mojave
    sha256 "79c267b41df839e7765fdfc4a8ab8a0145273189d8819ff090eeae17ce3c08cc" => :high_sierra
    sha256 "1c8f1ee03c0bb7488b1d9affebe991bc49a7a8f47c24e15a674f7fc9d1e483fa" => :sierra
  end

  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
