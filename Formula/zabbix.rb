class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.2.tar.gz"
  sha256 "dc908703fa560e94bfdaf1d585234ef09795513b9aedc5c6b4ea44dce3d1d6b2"
  license "GPL-2.0"

  bottle do
    sha256 "c315986435d2fc16410f756c9cadbf4b40d50d9592729bca4b11a33ac8d9eae7" => :catalina
    sha256 "f27b66332b604c902f6a42ce53b0e8c0b72c47a10e580cc65f9b3fb1fb32da4e" => :mojave
    sha256 "c6138330823cf52a44a4b8367d8fd318ae4e2f82d97d644c9228539bda73e1c3" => :high_sierra
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
