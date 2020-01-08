class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.4/zabbix-4.4.4.tar.gz"
  sha256 "7bf7ede7d182d4ff4f8321b9f3aafe6da50ee33696cf5fcc4811f084da37865f"

  bottle do
    sha256 "e07bd1222d8b09343f5492affac828807a52997b796a9d8e2b5d896a4a9b8b93" => :catalina
    sha256 "8696f7cebe346fc0cda905ebed1fefbe30f32a772d01d79fb81b6cc8e6a74b70" => :mojave
    sha256 "9e7351140f512c7eb9b6dbb69608f6b6351a2cd46b3750274f4129d14ef49c04" => :high_sierra
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
