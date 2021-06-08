class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.1.tar.gz"
  sha256 "dbfbcf6c6da31b832abb60e3ebdd93efff89a46015b0f250aebc01bf17afb57b"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "03eb986ad075fa4939fc5464cfce99d34161bbc7c7e3e9312afa48cf42e1911c"
    sha256 big_sur:       "50a6f1f6c51d331e78cdece8dd97735c4d57bc98ffa1865f808ed86f8febb5ab"
    sha256 catalina:      "d426454e44ad465c08a1d145e07aedcb00434eddccc4c1c9cc89084d083bee65"
    sha256 mojave:        "436199675147e85a4e769ccb7b5dee441ccdb07ecb51d8115613df6a21165e39"
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
