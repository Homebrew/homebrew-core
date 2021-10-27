class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.6.tar.gz"
  sha256 "e14b586e72c80fc48eca48fa46e27125d2b34d81e2073db0be2c5b87369e5e09"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "574a1da82b64cd125a08567a50f240248ca22d49d91d6388474cb14fce6910ef"
    sha256 arm64_big_sur:  "6373aa84f57907b0cbba8e5754ecf9e03633feb519a45614e6c9db594a2e2088"
    sha256 monterey:       "b5a04ab526dc8896b1ef86af066fc472101f358fb35e2dcdb35c0cf418a97679"
    sha256 big_sur:        "9609759325276301adab1d0f0268bb9977ad018726908339ea2c3b26c1a93450"
    sha256 catalina:       "a76e1daadb0a51de62de5ae6c102483135d35a80bbfe42359237d954f9515dcb"
    sha256 mojave:         "721b8e34c60e850140cb44a7981afce17d801176a355270b7c9877fc82a6bd4c"
    sha256 x86_64_linux:   "4007096ce747c0ee9cfb16afce860ae25e57a521fe11bdd02ba978064e83ef85"
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
