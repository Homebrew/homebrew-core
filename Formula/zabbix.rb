class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.2.0/zabbix-4.2.0.tar.gz"
  sha256 "4cdcd49ad43fab6b074365be2c424c2a86983156b49e359547cfc912bee93cad"

  bottle do
    sha256 "e2ad2423e8cc6b7430c334a459969da8112ee316aea48c7d1e76caa889e28161" => :mojave
    sha256 "b83cf9c0e670240e7cf20a722a5a53ecb64399ad46e30d0ad0ec833d1b86185b" => :high_sierra
    sha256 "d82ae97d28f6a101098dc778fc6ea9d2a6f60a2a616a0e06cff368a0d1ba042c" => :sierra
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
