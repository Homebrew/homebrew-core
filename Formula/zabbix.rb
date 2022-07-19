class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.0.tar.gz"
  sha256 "2de7cb68a0d0f09bfef66328ab885920afa6a3b0b57ce6e6fc6227b10a2be02a"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7dd2d7f625a3b16483491366f7e652f73ae3ca94fc4ee5efdd824ffe4e7a8bf9"
    sha256 arm64_big_sur:  "3254242b633bcc69cba5eefa3ef54928df48a7ad773e86e7ac9f6f36f6ff380f"
    sha256 monterey:       "2f2e9cf54b3b1c58dc7c33b4faba3b33ac70cb867e650b65f34ea70a473ba752"
    sha256 big_sur:        "c95a385602b7131468877815ffa2de1d5b5420c5e49768b92ba821d5c169b471"
    sha256 catalina:       "16ab2f0554078c62856fb995b15aa5eea3ced01b2a6eb6146e8b142662425e16"
    sha256 x86_64_linux:   "351e6b86ce32466a8b509f5efd734205ff23cb4471ea5dbb66ebb38a3d3232f0"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
