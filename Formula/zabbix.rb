class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.5.tar.gz"
  sha256 "3eeb7063efc5dad56f84dfdcf9aeb781044be712e11e83f66d043da55f33bdc2"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "03187314c76344360450d3db8d1eb592f2143d8093b055b73571fde117eb6d19"
    sha256 arm64_big_sur:  "c9f2ac0e4d866a16a82491ec73c9339da24381855f34eddf8184a4505bb3cba7"
    sha256 monterey:       "11f6d53439663bbb10b539db64f6ea5c02265f309dd02fde8125e990d2576ee9"
    sha256 big_sur:        "a2bb348493cd263d4e60565627e692057671cac5ca9095fed2d1c6ab5d08cb4e"
    sha256 catalina:       "591ce4a6478e97c8b59b4beb61ea0b299c2f78e7192e8a1a2b0e5a076bb4c8cf"
    sha256 x86_64_linux:   "fd03d3a3ad820b134a85668abed40b86a49a1282dafa18d92296f60684103323"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
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
