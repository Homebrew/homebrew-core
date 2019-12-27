class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.4/zabbix-4.4.4.tar.gz"
  sha256 "7bf7ede7d182d4ff4f8321b9f3aafe6da50ee33696cf5fcc4811f084da37865f"

  bottle do
    sha256 "6c068804843138afab45916c8f9ce11adf9f52159f0e2f0a32f9173f843f775b" => :catalina
    sha256 "9c737e8374decfa86743a737180b555960ac4450af75b0acf25174859ae3ad33" => :mojave
    sha256 "98dc9939625487b25b427a878e4508d46bf7623ea1d8ea1d373b5dcacf829bb6" => :high_sierra
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
