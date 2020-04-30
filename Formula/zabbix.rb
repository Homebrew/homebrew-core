class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/stable/4.4.8/zabbix-4.4.8.tar.gz"
  sha256 "c0562245c75fc86c2c22d9a8e521c147dea832056b869d27488ea6130a253651"

  bottle do
    sha256 "1a203e1675c77976ff2c164d1b38279d37fa31ea0bd70087939d265be80f5f99" => :catalina
    sha256 "6d346a086dc6938e37bcb41eebc9343a7730b012696125cfe309c4d90f7a04a1" => :mojave
    sha256 "056f1fb839febcbb0c4fa2f76f627676184ecb5254c13489753ea08283aaccc5" => :high_sierra
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
