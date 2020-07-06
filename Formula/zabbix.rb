class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.1.tar.gz"
  sha256 "20a19e5cf2354ffcbbe24521b04becfc9875e57289c00da71999de60c4a853b6"
  license "GPL-2.0"

  bottle do
    sha256 "2ac9eaa79b953244dda80543660b22150d7c6e9ce444386e5448f63cf76df412" => :catalina
    sha256 "0c52ff483bc2081662b76f0e0c5cfc10b933780a149bc14c29869ee3ea74f424" => :mojave
    sha256 "b336bc2a9533f0d54e2c6277cd3cd9de3577596049aa44bfbb4ba2791d3bfa9c" => :high_sierra
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
