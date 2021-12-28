class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.4/zabbix-5.4.9.tar.gz"
  sha256 "19686628df76e8d5ef7c2ed2975b258c7ca3ec7d151b1bb59d7e132f9fc7c941"
  license "GPL-2.0-or-later"
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "173136dbcbf1e52e04c326837865a1d3b3b2d4bb0da9e1bc1e60b3a0b336b510"
    sha256 arm64_big_sur:  "d412ee9ec8756e860c92735468fe6708a8ce1f1de9b7be640b727b5611248cf4"
    sha256 monterey:       "86b2dceab1a0653699cd8c3a1629e0a8d745ce51010f3f7c9666bcf543e9c9cc"
    sha256 big_sur:        "774a042f14c60b6f09e58850b4daff0792612df1622da0f0ac5c8476bc5a7fe2"
    sha256 catalina:       "b9329270de541dfdf2039526ad8be27bf136923728b3df57798694152623216c"
    sha256 x86_64_linux:   "c0309382bf3fbeda4651c911f58e3e839b8b65962ec08ab25e33e79e2675ea07"
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
