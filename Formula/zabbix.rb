class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.0.tar.gz"
  sha256 "501e148beef457a6a379ea4e318832d6c2c5a06176ea389d44581df8562dcb95"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git"

  bottle do
    sha256 arm64_big_sur: "471d08b2d02fabe955ddb2883f205e8d1abea3c010a0f6cfdf983217609ea15e"
    sha256 big_sur:       "1bde5c457da5e3b1bdbcb42ca10ccc6a420d1c8ec5638e1e14b8411fc43f6866"
    sha256 catalina:      "cfb91c2785a9cdf0bfa85e52757da6bd5b62bd4ce8867d6147031499ae7e2b08"
    sha256 mojave:        "6f2fd95bc5b1a86473bd482f0753b5d754d978b4dd10c9cc52ae527b8fb7f7d7"
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
