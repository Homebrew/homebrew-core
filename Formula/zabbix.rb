class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.6/zabbix-4.2.6.tar.gz"
  sha256 "646b1f29a768e3123a00a9afadf382b4d0dfd54e20fb31023f0d6da066da0864"

  bottle do
    sha256 "4b7e9c77b25eb3cd455bf5a4c73d1faf712ced74134da02dc38e3f770a8b2649" => :mojave
    sha256 "7e4e0b86bc28a29dc4a576df46aef513c54becb8fc6a23c17197500e3b63c9aa" => :high_sierra
    sha256 "db1aaa5e4614747bc2a07fb921719e24ea606538249b79374008ec08284d156a" => :sierra
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
