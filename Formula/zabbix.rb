class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.4.tar.gz"
  sha256 "de9985978cf9638d7cb208f7f65d93141b4e1256ead56df1b95d7bda41d6a672"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "4373c16468a34c494a111111c59355b46455ccaf91ff0405034806d2a089bc57"
    sha256 big_sur:       "87aa41c567e1ec52f24117b992877a3c859edac902723e4e03bddc293145cea2"
    sha256 catalina:      "7c3697291d893717faf0ec39643152e98509a1aad38c69e51df331c1f17c6e8e"
    sha256 mojave:        "34a042637df8d58df9bbd84ce15638c4b8da576ab5a8b5f86e3c7a724a0a10b4"
    sha256 x86_64_linux:  "e5cd2090baa1c65ae91bbfea560f5075ef4c52eac14c4a051aa82fc0ce888c21"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
