class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.13/zabbix-3.4.13.tar.gz"
  sha256 "115b70acc78954aac4da0a91012645a216ee4296a7b538b60c2198cc04b905bd"
  revision 1

  bottle do
    sha256 "d11ee560372330e53fc3118da1a8a7213f2cdb7afa75f75fa17e4fd287497c75" => :mojave
    sha256 "de98c4192b2c9366affdcfe4c0d8016e53abd5e9ec387bdd9789c81c1f85c292" => :high_sierra
    sha256 "dcd33eb99ad59b69d9bacd7972d96ae58af368589edbb30a6d9562d2976a5031" => :sierra
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

    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
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
