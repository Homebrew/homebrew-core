class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.2/zabbix-5.2.6.tar.gz"
  sha256 "76cb704f2a04fbc87bb3eff44fa71339c355d467f7bbd8fb53f8927c760e1680"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "3b21b8ffece10e46291db35e74def32b44965976ae5f6cdbabe1464037cf552c"
    sha256 big_sur:       "bdb8a1a1bbc6e6ccad8713b85090763d3525a16cf146da3328faa3ab551d76c4"
    sha256 catalina:      "6b257979b0f3a4c95ca8d048e67d8ecbf490605704ef1e30343be06e4333e289"
    sha256 mojave:        "7fe756223b38b4f67ad2e1ba59885193760d56475e69c62390cc9a86725182a5"
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
