class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.1.tar.gz"
  sha256 "dbfbcf6c6da31b832abb60e3ebdd93efff89a46015b0f250aebc01bf17afb57b"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "83510e5fff52c13c1444e73a71af668dc75539c477c3a4586ced65c0fba46241"
    sha256 big_sur:       "ace808c83e45d41f02a585d948c5ef5b9e7ba5b7a34872fb4aaff08e7c3baa7d"
    sha256 catalina:      "b87a7328b7bfae7369231ded96ef6b9cf0b65d7b5136eb5b19b628502956730d"
    sha256 mojave:        "9105ab4213b17a94068cfd75962d338df6c1f864021b7b3979029941fb9de6ca"
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
