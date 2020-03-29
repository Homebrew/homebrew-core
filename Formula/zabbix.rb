class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.6/zabbix-4.4.6.tar.gz"
  sha256 "22bb28e667424ad4688f47732853f4241df0e78a7607727b043d704ba726ae0e"

  bottle do
    sha256 "5b6604bbc81948ff42ca1653f9ab9aaded21637379e966c5e3384ebff5d76eeb" => :catalina
    sha256 "928e0dfde5c0b913e4959988864828ae64bf3caf053014a9a1667fb933af1a14" => :mojave
    sha256 "fe5f55c5ebf3f7ff3e4f4c4768540882cda85cd930d56d9edec76bc8454d890f" => :high_sierra
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
