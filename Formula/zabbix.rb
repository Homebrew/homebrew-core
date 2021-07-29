class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.3.tar.gz"
  sha256 "dbbc843c8119f1f63d7378588d5eb5a46c22f32f86428bb79b9872191342bbc2"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "f652cbabdf0e19818847e22c7a976060297ea96f099b26f969e3d7b18a7fcbc7"
    sha256 big_sur:       "28f7230bb8ebbdc989edd13bc1e0f1056c5d6616a81e5a1d0d1781636c9edf94"
    sha256 catalina:      "e04e30bcd523d19f9dbc1597e5ce62530e68a560b988e413725f41269c295dd9"
    sha256 mojave:        "6949f2cf1de7bc49943904c8f9dfec6524e9e1eed01de43a72351c8fa6b1c09b"
    sha256 x86_64_linux:  "542a037dd7a7b1b443c60462536620362d03ecfd28da2cb144e14c5192b9e24a"
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

    on_macos do
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
