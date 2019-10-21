class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.0/zabbix-4.4.0.tar.gz"
  sha256 "c47da70ea2379684ea6fad91092b819eda6e1955b215b9dd568c061143d78ca8"

  bottle do
    sha256 "242f824dde4930d5cec2b7492b3b4a4bee1397039e7963ed82dbab4b7e81b652" => :catalina
    sha256 "ab967d9e9261183072cc487697105e76a27e4cd14d921ffcba7624ecfc99a7d1" => :mojave
    sha256 "d482ae0c3b9320330c249118a84f0f1eb6d8c039d85814526d626b6b2c58f0bd" => :high_sierra
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
